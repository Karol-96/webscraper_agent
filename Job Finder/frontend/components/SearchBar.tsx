'use client';

export default function SearchBar() {
  return (
    <div className="w-full max-w-4xl mx-auto">
      <div className="relative">
        <input
          type="text"
          placeholder="What's trending right now?"
          className="w-full px-6 py-4 text-lg rounded-full border border-gray-200 
                   focus:outline-none focus:ring-2 focus:ring-blue-500 shadow-lg"
        />
        <button className="absolute right-3 top-3 bg-blue-500 text-white 
                          px-6 py-2 rounded-full hover:bg-blue-600 transition">
          Search
        </button>
      </div>
      <div className="mt-4 text-sm text-gray-500 text-center">
        Real-time updates from 50+ sources worldwide
      </div>
    </div>
  );
} 