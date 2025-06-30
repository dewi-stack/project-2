<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Category;
use App\Models\SubCategory;

class CategoryAndSubCategorySeeder extends Seeder
{
    public function run(): void
    {
        $data = [
            'Raw Material Bahan Aktif' => ['Herbisida', 'Insektisida', 'Fungisida', 'Lain-lain'],
            'Raw Material Supporting' => ['Herbisida', 'Insektisida', 'Fungisida', 'Lain-lain'],
            'Barang Dalam proses' => [], // Tidak punya subkategori
            'Barang Jadi' => ['Herbisida', 'Insektisida', 'Fungisida', 'Lain-lain'],
        ];

        foreach ($data as $categoryName => $subCategories) {
            $category = Category::create(['name' => $categoryName]);

            foreach ($subCategories as $subName) {
                SubCategory::create([
                    'name' => $subName,
                    'category_id' => $category->id,
                ]);
            }
        }
    }
}
