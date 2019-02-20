Return-Path: <SRS0=okv7=Q3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D06BDC43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Feb 2019 16:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAEA821773
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Feb 2019 16:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbfBTQhb convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Feb 2019 11:37:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:60412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725798AbfBTQhb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Feb 2019 11:37:31 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 208A82147C;
        Wed, 20 Feb 2019 16:37:30 +0000 (UTC)
Date:   Wed, 20 Feb 2019 11:37:28 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] kernel-shark: Fixing the fix of ksmodel_shif_forward
 method()
Message-ID: <20190220113728.09ff2c65@gandalf.local.home>
In-Reply-To: <ee313bc5-5d83-84bd-3578-8a5618fcc48c@gmail.com>
References: <20190220091610.10699-1-ykaradzhov@vmware.com>
        <20190220095152.0ec78bda@gandalf.local.home>
        <ee313bc5-5d83-84bd-3578-8a5618fcc48c@gmail.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 20 Feb 2019 17:29:34 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> On 20.02.19 г. 16:51 ч., Steven Rostedt wrote:
> > On Wed, 20 Feb 2019 11:16:10 +0200
> > Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
> >   
> >> As explaned in the change log of
> >>
> >> e54616484 ("Do not copy the Upper Overflow bin when shifting forward"),
> >>
> >> the lower edge of the Upper Overflow bin is unusual (shift + 1). Because
> >> of this, the content of the Upper Overflow bin cannot be copied, when
> >> shifting the visible area forward. It has to be recalculated instead.
> >> However, this is not enough to fix the bug. The last bin of the old histo
> >> cannot be copied as well. This is because its upper edge is shifted
> >> too (+1).
> >>
> >> Reported-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> >> Fixes: e54616484 ("Do not copy the Upper Overflow bin when shifting forward")
> >> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> >> ---
> >>   kernel-shark/src/libkshark-model.c | 17 ++++++++++++-----
> >>   1 file changed, 12 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/kernel-shark/src/libkshark-model.c b/kernel-shark/src/libkshark-model.c
> >> index b71a9b8..b80f71e 100644
> >> --- a/kernel-shark/src/libkshark-model.c
> >> +++ b/kernel-shark/src/libkshark-model.c
> >> @@ -488,23 +488,30 @@ void ksmodel_shift_forward(struct kshark_trace_histo *histo, size_t n)
> >>   	ksmodel_set_lower_edge(histo);
> >>   
> >>   	/*
> >> -	 * Copy the the mapping indexes of all overlaping bins starting from
> >> -	 * bin "0" of the new histo. Note that the number of overlaping bins
> >> -	 * is histo->n_bins - n.
> >>   	 * We will do a sanity check. ksmodel_set_lower_edge() sets map[0]
> >>   	 * index of the new histo. This index should then be equal to map[n]
> >>   	 * index of the old histo.
> >>   	 */
> >>   	assert (histo->map[0] == histo->map[n]);
> >> +
> >> +	/*
> >> +	 * Copy the mapping indexes of all overlaping bins starting from
> >> +	 * bin "0" of the new histo. Note that the number of overlaping bins
> >> +	 * is histo->n_bins - n. However, the last bin of the models is
> >> +	 * unusual. Its size has been increased by "1" in order make sure that
> >> +	 * the last entry of the dataset will fall into it (see the comment in
> >> +	 * ksmodel_set_next_bin_edge()). Because of this, we do not want to
> >> +	 * copy the very last bin of the old histo. We are going to recalculate
> >> +	 * its content instead. */
> >>   	memmove(&histo->map[0], &histo->map[n],
> >> -		sizeof(histo->map[0]) * (histo->n_bins - n));
> >> +		sizeof(histo->map[0]) * (histo->n_bins - n - 1));
> >>   
> >>   	/*
> >>   	 * Calculate only the content of the new (non-overlapping) bins.
> >>   	 * Start from the last copied bin and set the edge of each consecutive
> >>   	 * bin.
> >>   	 */
> >> -	bin = histo->n_bins - n - 1;
> >> +	bin = histo->n_bins - n - 2;  
> > 
> > Is it possible that we could have histo->n_bins == n - 1?  

Sorry, I meant n + 1.

histo->n_bins = 5, n = 4.

	bin = (5) - (4) - 2 = -1.

-- Steve

> 
> This is not possible.
> Several lines above in the code we have
> 
> 
> 	if (n >= histo->n_bins) {
> 		/*
> 		 * No overlap between the new and the old ranges. Recalculate
> 		 * all bins from scratch. First calculate the new range.
> 		 */
> 		ksmodel_set_bining(histo, histo->n_bins, histo->min,
> 							 histo->max);
> 
> 		ksmodel_fill(histo, histo->data, histo->data_size);
> 		return;
> 	}
