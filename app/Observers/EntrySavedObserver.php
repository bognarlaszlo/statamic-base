<?php

namespace App\Observers;

use Statamic\Events\EntrySaved;
use Statamic\Facades\Collection;

class EntrySavedObserver
{
    public function handle(EntrySaved $event)
    {
        if (! $event->entry->hasStructure()) return;

        $collection = $event->entry->collectionHandle();
        optional(Collection::findByHandle($collection))->updateEntryUris();
    }
}
