def add_dto(dto: str,cols: list):
    with open('dto.py', 'r') as f:
        for line in f.readlines():
            if line.strip() == f'class {dto}:':
                print(f"DTO class '{dto}' already exists.")
                return
    with open('dto.py', 'a') as f:
        f.write(f'\n\nclass {dto}:')
        f.write(f'\n    def __init__(self, {', '.join(cols)}):')
        for col in cols:
            f.write(f'\n        self.{col} = {col}')

add_dto('Store', ['store_id', 'store_name', 'phone', 'email', 'street', 'city', 'state', 'zip_code'])