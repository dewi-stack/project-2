<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SubCategoryRequest extends Model
{
    protected $fillable = [
        'name',
        'category_id',
        'status',
        'requested_by',
    ];

    public function category()
    {
        return $this->belongsTo(Category::class);
    }

    public function requester()
    {
        return $this->belongsTo(User::class, 'requested_by');
    }

    public function subCategory()
    {
        return $this->belongsTo(SubCategory::class, 'sub_category_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'requested_by');
    }
}

