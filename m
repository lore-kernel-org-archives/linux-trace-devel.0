Return-Path: <SRS0=m1Zh=MO=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:47554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725884AbeJCEDa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Oct 2018 00:03:30 -0400
Date: Tue, 2 Oct 2018 17:18:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] kernel-shark-qt: Fix a bug in
 kshark_data_collection_alloc()
Message-ID: <20181002171809.63a40b12@gandalf.local.home>
In-Reply-To: <20181001135921.32379-6-ykaradzhov@vmware.com>
References: <20181001135921.32379-1-ykaradzhov@vmware.com>
        <20181001135921.32379-6-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Mon,  1 Oct 2018 16:59:21 +0300
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> The margin data added at the end of the data interval of the collection
> may actually include the beginning of another interval. Because of this
> we have to iterate over the margin data and check for "good" entries. In
> the case of a "good" entry being found, we have to continue extending the
> last interval.
> 
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark-qt/src/libkshark-collection.c | 26 +++++++++++++++-------
>  1 file changed, 18 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel-shark-qt/src/libkshark-collection.c b/kernel-shark-qt/src/libkshark-collection.c
> index 79b6fff..c01eb59 100644
> --- a/kernel-shark-qt/src/libkshark-collection.c
> +++ b/kernel-shark-qt/src/libkshark-collection.c
> @@ -157,14 +157,24 @@ kshark_data_collection_alloc(struct kshark_context *kshark_ctx,
>  			 * number of margin entries requested, keep adding
>  			 * until you fill the margin.
>  			 */
> -			if (i + margin < j)
> -				i = j;
> -			else
> -				i += margin;
> -
> -			last_added = i;
> -			collection_add_entry(&temp, i, COLLECTION_BREAK);
> -			++break_count;
> +			if (i + margin >= j) {
> +				for (;j < i + margin; ++j) {
> +					if (cond(kshark_ctx, data[j], val)) {
> +						/* Good data has been found.

Nit, but have comments of the format:

						/*
						 * Good data has been found
> +						 * Continue extending the
> +						 * previous data interval.
> +						 */

Note, the Networking folks like the way you did it here, but the rest
of the Linux maintainers find it funny ;-)

-- Steve

> +						good_data = true;
> +						break;
> +					}
> +				}
> +			}
> +
> +			last_added = i = j;
> +			if (!good_data) {
> +				collection_add_entry(&temp, i, COLLECTION_BREAK);
> +				++break_count;
> +			}
>  		}
>  	}
>  
