Return-Path: <SRS0=q7JI=ZT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F243C432C0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Nov 2019 18:54:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F95820835
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Nov 2019 18:54:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfK0SyT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Nov 2019 13:54:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:33906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726984AbfK0SyS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Nov 2019 13:54:18 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 515EF2080F;
        Wed, 27 Nov 2019 18:54:18 +0000 (UTC)
Date:   Wed, 27 Nov 2019 13:54:16 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] kernel-shark: Fix potential memory leak in
 libkshark-collection
Message-ID: <20191127135416.6bcc0fd9@gandalf.local.home>
In-Reply-To: <20191023122145.14314-2-y.karadz@gmail.com>
References: <20191023122145.14314-1-y.karadz@gmail.com>
        <20191023122145.14314-2-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 23 Oct 2019 15:21:44 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> When searching for the entry, do not loop over the original list of
> requests. Use a copy instead. If we loop over the original list and
> no entry is found in the first element of the list, later the memory
> used for this first element will leak.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  kernel-shark/src/libkshark-collection.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel-shark/src/libkshark-collection.c b/kernel-shark/src/libkshark-collection.c
> index 02a014e..95fdbab 100644
> --- a/kernel-shark/src/libkshark-collection.c
> +++ b/kernel-shark/src/libkshark-collection.c
> @@ -622,6 +622,7 @@ kshark_get_collection_entry_front(struct kshark_entry_request **req,
>  				  ssize_t *index)
>  {
>  	const struct kshark_entry *entry = NULL;
> +	struct kshark_entry_request *list;

Hi Yordan,

I was looking at this patch in more detail, and I'm thinking that we
don't need to pass in the address of the req pointer, but just the req
pointer itself. The only place that I see the req pointer being
modified is the failure case in map_collection_request_init() where it
does:

	kshark_free_entry_request(*req);
	*req = NULL;

But all callers do that free anyway.

Maybe I'm missing something, but why are we passing in the pointer to
the pointer of req, and not just the req pointer itself? I don't see a
need to modify the pointer.

Before this patch, *req is modified, but after this patch, it is not.
If you pass in just "struct kshark_entry_request *req" then you don't
even need to have the "list" variable, you could just use "req" because
that would be a copy of the pointer.

-- Steve



>  	int req_count;
>  
>  	/*
> @@ -638,12 +639,10 @@ kshark_get_collection_entry_front(struct kshark_entry_request **req,
>  	 * Loop over the list of redefined requests and search until you find
>  	 * the first matching entry.
>  	 */
> -	while (*req) {
> -		entry = kshark_get_entry_front(*req, data, index);
> +	for (list = *req; list; list = list->next) {
> +		entry = kshark_get_entry_front(list, data, index);
>  		if (entry)
>  			break;
> -
> -		*req = (*req)->next;
>  	}
>  
>  	return entry;
> @@ -680,6 +679,7 @@ kshark_get_collection_entry_back(struct kshark_entry_request **req,
>  				 ssize_t *index)
>  {
>  	const struct kshark_entry *entry = NULL;
> +	struct kshark_entry_request *list;
>  	int req_count;
>  
>  	/*
> @@ -695,12 +695,10 @@ kshark_get_collection_entry_back(struct kshark_entry_request **req,
>  	 * Loop over the list of redefined requests and search until you find
>  	 * the first matching entry.
>  	 */
> -	while (*req) {
> -		entry = kshark_get_entry_back(*req, data, index);
> +	for (list = *req; list; list = list->next) {
> +		entry = kshark_get_entry_back(list, data, index);
>  		if (entry)
>  			break;
> -
> -		*req = (*req)->next;
>  	}
>  
>  	return entry;

