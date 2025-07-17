<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CategoryRequest extends Model
{
    protected $fillable = [
        'category_id', 'name', 'action', 'status', 'requested_by',
    ];

    public function category()
    {
        return $this->belongsTo(Category::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'requested_by');
    }
}
