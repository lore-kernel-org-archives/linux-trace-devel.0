Return-Path: <SRS0=CcWV=UL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C2CCC31E46
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 14:28:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8095C208CA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 14:28:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437520AbfFLO2e (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 Jun 2019 10:28:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437330AbfFLO2d (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Jun 2019 10:28:33 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F208B2082C;
        Wed, 12 Jun 2019 14:28:32 +0000 (UTC)
Date:   Wed, 12 Jun 2019 10:28:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com
Subject: Re: [PATCH 1/2] kernel-shark: Fix a bug in
 ksmodel_set_next_bin_edge() part II
Message-ID: <20190612102831.15fca926@gandalf.local.home>
In-Reply-To: <20190612142053.14439-1-ykaradzhov@vmware.com>
References: <20190612142053.14439-1-ykaradzhov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Hi Yordan,

Please use a more descriptive subject. Seeing a "part II" and a "part
III" in a git log --oneline isn't very useful.

Something like:

 kernel-shark: Only increment the upper edge bin without touching lower edge.

Or something that describes what is being done in a bit more detail.

Thanks!

-- Steve

On Wed, 12 Jun 2019 17:20:52 +0300
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> On a first glance this patch may looks like reverting commit
> 9336dd6bcd38 (kernel-shark: Fix a bug in ksmodel_set_next_bin_edge())
> 
> The point is that for the last bin we want to increment its upper edge
> used  when checking if the bin is empty, but we do not want to touch
> the lower edge time used by kshark_find_entry_by_time().
> 
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark/src/libkshark-model.c | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel-shark/src/libkshark-model.c b/kernel-shark/src/libkshark-model.c
> index 978cd70..0cac924 100644
> --- a/kernel-shark/src/libkshark-model.c
> +++ b/kernel-shark/src/libkshark-model.c
> @@ -260,20 +260,30 @@ static size_t ksmodel_set_upper_edge(struct kshark_trace_histo *histo)
>  static void ksmodel_set_next_bin_edge(struct kshark_trace_histo *histo,
>  				      size_t bin, size_t last_row)
>  {
> -	size_t time, next_bin = bin + 1;
> +	size_t time_min, time_max, next_bin = bin + 1;
>  	ssize_t row;
>  
> -	/* Calculate the beginning of the next bin. */
> -	time = histo->min + next_bin * histo->bin_size;
> +	/* Calculate the beginning and the end of the next bin. */
> +	time_min = histo->min + next_bin * histo->bin_size;
> +	time_max = time_min + histo->bin_size;
> +	/*
> +	 * The timestamp of the very last entry of the dataset can be exactly
> +	 * equal to the value of the upper edge of the range. This is very
> +	 * likely to happen when we use ksmodel_set_in_range_bining(). In this
> +	 * case we have to increase the size of the very last bin in order to
> +	 * make sure that the last entry of the dataset will fall into it.
> +	 */
> +	if (next_bin == histo->n_bins - 1)
> +		++time_max;
>  
>  	/*
>  	 * Find the index of the first entry inside
> -	 * the next bin (timestamp > time).
> +	 * the next bin (timestamp > time_min).
>  	 */
> -	row = kshark_find_entry_by_time(time, histo->data, last_row,
> +	row = kshark_find_entry_by_time(time_min, histo->data, last_row,
>  					histo->data_size - 1);
>  
> -	if (row < 0 || histo->data[row]->ts >= time + histo->bin_size) {
> +	if (row < 0 || histo->data[row]->ts >= time_max) {
>  		/* The bin is empty. */
>  		histo->map[next_bin] = KS_EMPTY_BIN;
>  		return;

