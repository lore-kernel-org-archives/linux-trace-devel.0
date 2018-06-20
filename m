Return-Path: <SRS0=8rzQ=JG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:37318 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754161AbeFTSEw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Jun 2018 14:04:52 -0400
Received: by mail-wm0-f65.google.com with SMTP id r125-v6so1119520wmg.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jun 2018 11:04:52 -0700 (PDT)
From: Yordan Karadzhov <y.karadz@gmail.com>
Subject: Re: [PATCH v2 2/2] trace-filter: Change the hashing function used
 when filtering
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
References: <20180619132259.21387-1-y.karadz@gmail.com>
 <20180619132259.21387-2-y.karadz@gmail.com>
 <20180620112113.67dbdb4f@gandalf.local.home>
Message-ID: <129b43b8-e526-b8b7-f581-144fd82d2dd1@Gmail.com>
Date: Wed, 20 Jun 2018 21:04:48 +0300
MIME-Version: 1.0
In-Reply-To: <20180620112113.67dbdb4f@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On 20.06.2018 18:21, Steven Rostedt wrote:
> On Tue, 19 Jun 2018 16:22:59 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
>
>> diff --git a/kernel-shark/include/trace-filter-hash.h b/kernel-shark/include/trace-filter-hash.h
>> index 5cc39dc..98c9ab3 100644
>> --- a/kernel-shark/include/trace-filter-hash.h
>> +++ b/kernel-shark/include/trace-filter-hash.h
>> @@ -20,7 +20,7 @@
>>   #ifndef _TRACE_FILTER_HASH_H
>>   #define _TRACE_FILTER_HASH_H
>>   
>> -#include "trace-hash-local.h"
>> +#include <stdint.h>
>>   
>>   struct filter_id_item {
>>   	struct filter_id_item	*next;
>> @@ -47,4 +47,39 @@ static inline int filter_task_count(struct filter_id *hash)
>>   	return hash->count;
>>   }
>>   
>> +/*
>> + * Hashing functions, based on Donald E. Knuth's Multiplicative hashing.
>> + * See The Art of Computer Programming (TAOCP).
>> + */
>> +
>> +static inline uint8_t knuth_hash8(uint32_t val)
>> +{
>> +	/*
>> +	 * Multiplicative hashing function.
>> +	 * Multiplication by the Prime number, closest to the golden
>> +	 * ratio of 2^8.
>> +	 */
>> +	return UINT8_C(val) * UINT8_C(157);
>> +}
>> +
>> +static inline uint16_t knuth_hash16(uint32_t val)
>> +{
>> +	/*
>> +	 * Multiplicative hashing function.
>> +	 * Multiplication by the Prime number, closest to the golden
>> +	 * ratio of 2^16.
>> +	 */
>> +	return UINT16_C(val) * UINT16_C(40507);
>> +}
>> +
>> +static inline uint32_t knuth_hash(uint32_t val)
> BTW, is there any reason to have these in the header file? Shouldn't
> they be in a C file?
>
> The reason I ask is because this is going to be in a more public file,
> and I need to rename the functions for namespace reasons. These are
> someone out of place for a library header.


My only reason for having the hash functions in the header is to make sure
that the user will be aware that those are cheap and fast functions, but 
using
those functions makes sense only in the case when we have relatively small
number of items in the hash table. Nevertheless, If you prefer the 
implementation
to be in the .c file this is OK.

Yordan


> -- Steve
>
>
>> +{
>> +	/*
>> +	 * Multiplicative hashing function.
>> +	 * Multiplication by the Prime number, closest to the golden
>> +	 * ratio of 2^32.
>> +	 */
>> +	return val * UINT32_C(2654435761);
>> +}
>> +
