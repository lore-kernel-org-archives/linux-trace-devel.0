Return-Path: <SRS0=lLCO=RD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4032C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 19:08:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B37A620C01
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 19:08:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FP1DmMvr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbfB1TIF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Feb 2019 14:08:05 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34368 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbfB1TIF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Feb 2019 14:08:05 -0500
Received: by mail-qk1-f196.google.com with SMTP id a15so12766390qkc.1;
        Thu, 28 Feb 2019 11:08:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gY/eN3dNE9VGGR0tbNCSzKwh5eQv624Pzq8V/GLMbAQ=;
        b=FP1DmMvr3kdvlxEtRpCks7bIbGwY49+Gr64xd3JpJzFWhEJhBHikc9ntXsj4GWVfkU
         7HfxMZ6Kwjp6nhzS8UQubTzjOoc2epxgxtIomDOHF/Fc2jnxlQhQ19cTs39TgWNqJB4p
         gfV4wIKmFryv+t37mmirWqWZ2LYfPCVOAvcn2hOiCMhJuqTo2dFGnRSZR9y8AcjcBckA
         h2AJXPS8duJgTDs33+JtgHK2o0hXL0KcK3qg9SwfYnYLtbnSrDkMzHrgxlmNLZ5Xhwe4
         F8IM4YbUREEs8JJj/WHq1lSvb/nAmlw7/saVEO7nqtlVuS12RD1s8Crq0FwKpWvM6Xhg
         V/tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gY/eN3dNE9VGGR0tbNCSzKwh5eQv624Pzq8V/GLMbAQ=;
        b=NIWtYVGH4iLbvWfkKasK1KGCG8qlXKWbEsbTKcxhFpH2XNkPRpjD6rc4cEBzCK+9zt
         NBzsIvHtKwiWko9YWFYweYXJxCJmshT8rKtd3nV+tugU48A/QHBwxg21zeKazAthGDEF
         4Xq+BhMFytLrK1mogK2zoSQvhclAoKf0K+hGX8E5OHXKoKf1bsDQFvKw9E82dDtmDNe2
         9Dd8X2VGgWxS7nQ8eCIq2Z1vrA/2eve1ij5TJqP9wilJqQz92YHKyi3YZsy/2wlDSmgh
         vvjTw/IxdkT60I1l7WgSSlqxQRLQCN56glSEUenoVUhjeZkxU4RunXYB4jXOr3FCGOaH
         rlqw==
X-Gm-Message-State: APjAAAX4Qo1JlpVUjPhuIUiU//QXWbZJPGk33Aqun1JQqT+w86NPVUpf
        472lJ5LJYJ4iWMpclb8hfaY=
X-Google-Smtp-Source: APXvYqxER8xTvd9KBPkmtpXAy0XRLgzO22qmZgz8H1zpICv0TTrm3zDGJ9uh8TNYH+a0UJP9LRX/2Q==
X-Received: by 2002:a05:620a:123b:: with SMTP id v27mr779308qkj.29.1551380883726;
        Thu, 28 Feb 2019 11:08:03 -0800 (PST)
Received: from quaco.ghostprotocols.net ([179.97.35.11])
        by smtp.gmail.com with ESMTPSA id l24sm13331678qtf.27.2019.02.28.11.08.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Feb 2019 11:08:02 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 710414039C; Thu, 28 Feb 2019 16:07:59 -0300 (-03)
Date:   Thu, 28 Feb 2019 16:07:59 -0300
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Tony Jones <tonyj@suse.de>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-perf-users@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Michael Sartain <mikesart@fastmail.com>
Subject: Re: [PATCH] tools lib traceevent: Fix buffer overflow in arg_eval
Message-ID: <20190228190759.GL9508@kernel.org>
References: <20190228015532.8941-1-tonyj@suse.de>
 <20190227221250.74996869@vmware.local.home>
 <20190228190123.GK9508@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190228190123.GK9508@kernel.org>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Em Thu, Feb 28, 2019 at 04:01:23PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Wed, Feb 27, 2019 at 10:12:50PM -0500, Steven Rostedt escreveu:
> > On Wed, 27 Feb 2019 17:55:32 -0800
> > Tony Jones <tonyj@suse.de> wrote:
> > 
> > > Fix buffer overflow observed when running perf test.
> > > 
> > > The overflow is when trying to evaluate "1ULL << (64 - 1)" which
> > > is resulting in -9223372036854775808 which overflows the 20 character
> > > buffer.
> > > 
> > > If is possible this bug has been reported before but I still don't
> > > see any fix checked in:
> > > 
> > > See: https://www.spinics.net/lists/linux-perf-users/msg07714.html
> > > 
> > > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > > Cc: linux-perf-users@vger.kernel.org
> > > Cc: Steven Rostedt <rostedt@goodmis.org>
> > > Signed-off-by: Tony Jones <tonyj@suse.de>
> > 
> > Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > 
> > I have to say I've let this slide and it is not the first time a patch
> > went out with this fix. But this one has the correct fix because we
> > should use a buffer with a multiple of 4. Anyway, Tony I believe was
> > the first to report this anyway.
> > 
> > For reference we have:
> > 
> > I first heard about Tony's complaint on a post to linux-perf-users on Jan 18.
> > 
> > But then we had after that:
> > 
> >  Michael Sartain reported it on 1/24 (and fixed by Tzvetomir)
> >  https://lore.kernel.org/linux-trace-devel/20190125102014.19600-1-tstoyanov@vmware.com/
> >  
> > It was later fixed again by Mathias Krause
> >  https://lore.kernel.org/linux-trace-devel/20190223122404.21137-1-minipli@googlemail.com/
> > 
> > But since Tony was first to report it, and we discussed that it should
> > be 24 bytes, I would say this is the patch to take.
> > 
> > Again, sorry for not getting this acknowledged earlier and everyone doing
> > the same thing multiple times. :-/
> > 
> > Arnaldo, please take this patch. But also add:
> > 
> > Reported-by: Michael Sartain <mikesart@fastmail.com>
> > Reported-by: Mathias Krause <minipli@googlemail.com>
> 
> Will do.
> 
> Thanks for the credit research,

Some more research, an approximation, adding:

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Fixes: f7d82350e597 ("tools/events: Add files to create libtraceevent.a")

That is the 'git blame' entry for when that line was added with sizeof
== 20

- Arnaldo
