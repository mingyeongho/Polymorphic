#!/bin/bash

# 컴포넌트 생성 스크립트
# 사용법
# npm run gen_component [layer] ([slice]) [component] (-- [-t] [-s])

# 유효한 layer인지 확인하는 함수
is_valid_layer() {
    local valid_layers=("shared" "entities" "features" "widgets" "pages" "app")
    for layer in "${valid_layers[@]}"; do
        if [ "$layer" == "$1" ]; then
            return 0
        fi
    done
    return 1
}

# 컴포넌트 이름이 이미 존재하는지 확인하는 함수
is_component_exists() {
    local layer="$1"
    local slice="$2"
    local component="$3"

    local component_path
    if [ "$layer" == "shared" ]; then
        component_path="src/components/$layer/$component"
    else
        component_path="src/components/$layer/$slice/$component"
    fi

    if [ -e "$component_path" ]; then
        echo "Error: Component '$component' already exists in the '$layer/$slice' layer."
        return 0
    fi

    return 1
}

# 배럴 파일 업데이트 함수
update_barrel_file() {
    local file_path="$1"
    local export_statement="$2"

    # 파일이 존재하지 않으면 새로 생성하고 export_statement 추가
    if [ ! -f "$file_path" ]; then
        echo "$export_statement" > "$file_path"
        return
    fi

    # 이미 export_statement가 있는지 체크하여 중복 추가 방지
    if ! grep -Fxq "$export_statement" "$file_path"; then
        echo "$export_statement" >> "$file_path"
    fi
}

# main 함수
main() {
    local layer="$1"
    shift
    local slice=""
    local component=""
    
    # shared 레이어의 경우 slice가 없음
    if [ "$layer" == "shared" ]; then
        component="$1"
        shift
    else
        slice="$1"
        component="$2"
        shift 2
    fi

    local generate_type=false
    local generate_style=false

    # 옵션 처리
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            -t) generate_type=true ;;
            -s) generate_style=true ;;
            *) echo "Invalid option: $1" >&2; exit 1 ;;
        esac
        shift
    done

    # 유효한 layer인지 확인
    if ! is_valid_layer "$layer"; then
        echo "Error: '$layer' is not a valid layer. Choose from shared, entities, features, widgets, pages, app."
        exit 1
    fi

    # slice와 component가 제공되지 않은 경우 에러 처리
    if [ "$layer" != "shared" ] && { [ -z "$slice" ] || [ -z "$component" ]; }; then
        echo "Error: Both slice and component must be provided for the '$layer' layer."
        exit 1
    fi

    # 이미 존재하는지 확인
    if is_component_exists "$layer" "$slice" "$component"; then
        exit 1
    fi

    # 경로 설정
    local component_path
    if [ "$layer" == "shared" ]; then
        component_path="src/components/$layer/$component"
    else
        component_path="src/components/$layer/$slice/$component"
    fi

    mkdir -p "$component_path"

    # 파일 생성
    touch "$component_path/$component.tsx"
    echo "export default function $component() { return <div>$component</div>; }" > "$component_path/$component.tsx"

    echo "${generate_type}"
    echo "${generate_style}"

    # 타입 파일 생성 옵션이 설정된 경우
    if $generate_type; then
        touch "$component_path/$component.type.ts"
        echo "export interface I${component}Props {}" > "$component_path/$component.type.ts"
    fi

    # 스타일 파일 생성 옵션이 설정된 경우
    if $generate_style; then
        touch "$component_path/$component.style.ts"
        echo "// Add your styles here" > "$component_path/$component.style.ts"
    fi

    # 배럴 파일 생성
    touch "$component_path/index.ts"
    echo "export { default } from './$component';" > "$component_path/index.ts"
    if $generate_type; then
        echo "export type * from './$component.type';" >> "$component_path/index.ts"
    fi

    # 레이어의 배럴 파일 업데이트
    local barrel_path=""
    if [ "$layer" == "shared" ]; then
        barrel_path="src/components/$layer/index.ts"
        update_barrel_file "$barrel_path" "export * from './$component';"
        if $generate_type; then
            update_barrel_file "$barrel_path" "export type * from './$component';"
        fi
    else
        barrel_path="src/components/$layer/$slice/index.ts"
        update_barrel_file "$barrel_path" "export * from './$component';"
        if $generate_type; then
            update_barrel_file "$barrel_path" "export type * from './$component';"
        fi

        barrel_path="src/components/$layer/index.ts"
        update_barrel_file "$barrel_path" "export * from './$slice';"
        if $generate_type; then
            update_barrel_file "$barrel_path" "export type * from './$slice';"
        fi
    fi

    # 전체 컴포넌트 폴더의 배럴 파일 업데이트
    barrel_path="src/components/index.ts"
    update_barrel_file "$barrel_path" "export * from './$layer';"

    echo "Component created at $component_path"
}

# 스크립트 실행
main "$@"
