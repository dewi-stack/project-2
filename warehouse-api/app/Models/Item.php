<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Item extends Model
{
    use HasFactory;

    protected $fillable = [
        'sku',
        'name',
        'category_id',
        'stock',
        'location',
        'description',
        'user_id'
    ];

    public function category()
    {
        return $this->belongsTo(Category::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function keluar()
    {
        return $this->hasMany(ItemOut::class);
    }

    public function stockRequests()
    {
        return $this->hasMany(StockRequest::class);
    }


}

