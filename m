Return-Path: <SRS0=TDtF=UZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 786C1C48BD3
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jun 2019 19:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46CD821726
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jun 2019 19:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbfFZTeE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jun 2019 15:34:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbfFZTeD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 15:34:03 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA487216FD;
        Wed, 26 Jun 2019 19:34:02 +0000 (UTC)
Date:   Wed, 26 Jun 2019 15:34:01 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Greg Thelen <gthelen@google.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: Re: [PATCH] trace-cmd: remove ununsed knuth_hash*() routines
Message-ID: <20190626153401.645b1174@gandalf.local.home>
In-Reply-To: <20190626060101.220607-1-gthelen@google.com>
References: <20190626060101.220607-1-gthelen@google.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 25 Jun 2019 23:01:01 -0700
Greg Thelen <gthelen@google.com> wrote:

> Neither knuth_hash16() nor knuth_hash() are used.
> Delete them.
> 

Yordan,

Do you foresee that we will be using the other two versions of the hash?

-- Steve

> Signed-off-by: Greg Thelen <gthelen@google.com>
> ---
>  lib/trace-cmd/trace-filter-hash.c | 20 --------------------
>  1 file changed, 20 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-filter-hash.c b/lib/trace-cmd/trace-filter-hash.c
> index 39b28790e0bc..c56628f69ff0 100644
> --- a/lib/trace-cmd/trace-filter-hash.c
> +++ b/lib/trace-cmd/trace-filter-hash.c
> @@ -29,26 +29,6 @@ static inline uint8_t knuth_hash8(uint32_t val)
>  	return UINT8_C(val) * UINT8_C(157);
>  }
>  
> -static inline uint16_t knuth_hash16(uint32_t val)
> -{
> -	/*
> -	 * Multiplicative hashing function.
> -	 * Multiplication by the Prime number, closest to the golden
> -	 * ratio of 2^16.
> -	 */
> -	return UINT16_C(val) * UINT16_C(40507);
> -}
> -
> -static inline uint32_t knuth_hash(uint32_t val)
> -{
> -	/*
> -	 * Multiplicative hashing function.
> -	 * Multiplication by the Prime number, closest to the golden
> -	 * ratio of 2^32.
> -	 */
> -	return val * UINT32_C(2654435761);
> -}
> -
>  struct tracecmd_filter_id_item *
>  tracecmd_filter_id_find(struct tracecmd_filter_id *hash, int id)
>  {

