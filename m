Return-Path: <SRS0=lLCO=RD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A00DC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 19:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E264520854
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 19:01:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g4ffMHZj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730388AbfB1TBa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Feb 2019 14:01:30 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46787 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727165AbfB1TB2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Feb 2019 14:01:28 -0500
Received: by mail-qt1-f195.google.com with SMTP id z25so24754473qti.13;
        Thu, 28 Feb 2019 11:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0rnACV3hbRWsqpW2HE8Ikf+ekHji4cbWGZSHPV64ldU=;
        b=g4ffMHZjCyu8x11WY1if256v35ur3sP069P/zNgpF7GpDf/VXZS5HIroFO+kNIu2bu
         VmDCq3/nYP3oPfkoo/JI9MZkcBZ1ick7VSZDHibf/7GjTZjHGU4cXT/tPpF6JdY3tw07
         3mlkWSe35r9Wp4QW9thC+Mb7fr3Qw2gZhv0wogEVIWl6zljMbmFY6Be8ffrua3ww0j9/
         H0Q5uBdHMg2OIHaHm9Y3xfsjKVE0uT20qDf8d+QS3ElII+v9Z3G0ok/UZxkSjHwvgR3Z
         qseQJ6PQ/uU7meM+dDPlC8Nx5iNl4QQusxxVJDXeuzGWS09VZhFnpu4eEO3XEWDyQcwq
         0AXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0rnACV3hbRWsqpW2HE8Ikf+ekHji4cbWGZSHPV64ldU=;
        b=KlpOIc5qZvy3tzVRQKF4VR9p0n81JV7+ZZChGwuZNkjVsxAexHNi9Uefv2h0VWnH8o
         HGcMbvuuw4PEEC7w23tXi0JHKv69jw3JCuSbVzNRozPlIC9cOaik1R/DIbBVfNQr7CTr
         Rr22ez6FQGtQqcigfCEFZY374qFKZ3ASthuNNwJt5fUTOBcCPTTISbo9lqya7dp7H9pY
         j5lVntx2NRdc2P4lo2BJrP4eyELi1T+h4ugiTtNAgV6+8BtkYSpu7UfYnEj0ul4r2RrV
         74JirG9zYgMtCkCY0/KZhkRW2DxnTKXwjJN2x3t3D6y3eRL0/1TJGntN/pkP8fWxoOos
         9RcA==
X-Gm-Message-State: APjAAAXFgFIScgXxQMMYkbawM6enViO2bPZyCLDntsNq1DJXsCSCkamT
        5mX/DBVcBG62JrSsRS/ayAQ=
X-Google-Smtp-Source: APXvYqwunXF92TgKBDvISyf/yJMZ2M3u2YakqBICyX24YzEmmTQ0hmNBzZ4WzDLQC61UeCdTQH40zA==
X-Received: by 2002:a0c:b5ed:: with SMTP id o45mr564914qvf.242.1551380486929;
        Thu, 28 Feb 2019 11:01:26 -0800 (PST)
Received: from quaco.ghostprotocols.net ([179.97.35.11])
        by smtp.gmail.com with ESMTPSA id u18sm7800687qka.25.2019.02.28.11.01.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Feb 2019 11:01:25 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 74E724039C; Thu, 28 Feb 2019 16:01:23 -0300 (-03)
Date:   Thu, 28 Feb 2019 16:01:23 -0300
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Tony Jones <tonyj@suse.de>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-perf-users@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Michael Sartain <mikesart@fastmail.com>
Subject: Re: [PATCH] tools lib traceevent: Fix buffer overflow in arg_eval
Message-ID: <20190228190123.GK9508@kernel.org>
References: <20190228015532.8941-1-tonyj@suse.de>
 <20190227221250.74996869@vmware.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190227221250.74996869@vmware.local.home>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Em Wed, Feb 27, 2019 at 10:12:50PM -0500, Steven Rostedt escreveu:
> On Wed, 27 Feb 2019 17:55:32 -0800
> Tony Jones <tonyj@suse.de> wrote:
> 
> > Fix buffer overflow observed when running perf test.
> > 
> > The overflow is when trying to evaluate "1ULL << (64 - 1)" which
> > is resulting in -9223372036854775808 which overflows the 20 character
> > buffer.
> > 
> > If is possible this bug has been reported before but I still don't
> > see any fix checked in:
> > 
> > See: https://www.spinics.net/lists/linux-perf-users/msg07714.html
> > 
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: linux-perf-users@vger.kernel.org
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Signed-off-by: Tony Jones <tonyj@suse.de>
> 
> Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> 
> I have to say I've let this slide and it is not the first time a patch
> went out with this fix. But this one has the correct fix because we
> should use a buffer with a multiple of 4. Anyway, Tony I believe was
> the first to report this anyway.
> 
> For reference we have:
> 
> I first heard about Tony's complaint on a post to linux-perf-users on Jan 18.
> 
> But then we had after that:
> 
>  Michael Sartain reported it on 1/24 (and fixed by Tzvetomir)
>  https://lore.kernel.org/linux-trace-devel/20190125102014.19600-1-tstoyanov@vmware.com/
>  
> It was later fixed again by Mathias Krause
>  https://lore.kernel.org/linux-trace-devel/20190223122404.21137-1-minipli@googlemail.com/
> 
> But since Tony was first to report it, and we discussed that it should
> be 24 bytes, I would say this is the patch to take.
> 
> Again, sorry for not getting this acknowledged earlier and everyone doing
> the same thing multiple times. :-/
> 
> Arnaldo, please take this patch. But also add:
> 
> Reported-by: Michael Sartain <mikesart@fastmail.com>
> Reported-by: Mathias Krause <minipli@googlemail.com>

Will do.

Thanks for the credit research,

- Arnaldo
