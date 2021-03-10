Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05DABC433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Mar 2021 17:17:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C70AB64FC9
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Mar 2021 17:17:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbhCJRRI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Mar 2021 12:17:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:46636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229828AbhCJRQl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Mar 2021 12:16:41 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55BCF64FC6;
        Wed, 10 Mar 2021 17:16:41 +0000 (UTC)
Date:   Wed, 10 Mar 2021 12:16:39 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Vincent Donnefort <vincent.donnefort@arm.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Fix mmap error path in allocate_page_map()
Message-ID: <20210310121639.644d04d5@gandalf.local.home>
In-Reply-To: <20210310152730.3661-1-vincent.donnefort@arm.com>
References: <20210310152730.3661-1-vincent.donnefort@arm.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 10 Mar 2021 15:27:30 +0000
Vincent Donnefort <vincent.donnefort@arm.com> wrote:

> A typo in allocate_page_map() led to not testing mmap failure and using
> the defunct pointer as a valid one.
> 
> Signed-off-by: Vincent Donnefort <vincent.donnefort@arm.com>
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index f9d09d2..2093a3d 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -1004,7 +1004,7 @@ static void *allocate_page_map(struct tracecmd_input *handle,
>  	page_map->map = mmap(NULL, map_size, PROT_READ, MAP_PRIVATE,
>  			 handle->fd, map_offset);
>  
> -	if (page->map == MAP_FAILED) {
> +	if (page_map->map == MAP_FAILED) {
>  		/* Try a smaller map */
>  		map_size >>= 1;
>  		if (map_size < handle->page_size) {

Ouch. Nice catch!

I'll apply it to my next push to the tree.

-- Steve
