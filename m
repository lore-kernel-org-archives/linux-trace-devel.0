Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F6AFC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 17:59:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 438BC20851
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 17:59:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="PGGluBav"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfCHR7D (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 12:59:03 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46444 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbfCHR7C (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 12:59:02 -0500
Received: by mail-qk1-f193.google.com with SMTP id i5so11648637qkd.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 09:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=W1f5Wda2J5uNjk6aESlDfe8IAn1m1fVzVi5fETvAmjo=;
        b=PGGluBavue/FAI7gDizroJBHQxP2yBnK2z4wjABJrLUhGG+lKAcIgE/dHw260BRckE
         LUUh60Jmy/fgTOVDMDxthpTxwlmPRrVk8lwop0ekHWI6savbJLDZZHCyFja7GoEYYfnR
         O9thZOeAIs7VI3jjClE40IXZ/fVXQYvpdkw84=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=W1f5Wda2J5uNjk6aESlDfe8IAn1m1fVzVi5fETvAmjo=;
        b=hZQPjBxAOXCLPDVRM09f/YIXn/7OCYs2rLE7FreSl5EZaelGglYDSGihRn2DhbSSjj
         hZ2MQMTAttmeafNSBJoZ1McML+ovKmGAGcpQ2IwiVDaCDkbhZD5LP4rdV250mT2gSsBD
         8vKZ9GsQa753eu+MYT9ojvFUXy3ltZtmPlOyMClX6ZKGN9fwcUPxoxIv0UAlcRuiTq13
         ahsiNEmU1KahIw8plxeMmEunAVbw7FmjZquAL1QPV8poUHb7rWJVHvWgwMvJP/WmpWFq
         AiszsaVTdRasZOg2znqHCBCFhEcTHaglsIZW0scfVfaJvNOiXbo7RFlXf3FjJWUQkuJN
         8sTQ==
X-Gm-Message-State: APjAAAVp8bFjXDxp/10sZCv1BbJdm5KWysO2xc0Jdlgnovggg4mSSodt
        ikCXlOfxnaui3Kqah5ULPN4qfg==
X-Google-Smtp-Source: APXvYqyxAp+nrfAmh3cy9iq/s8pjc1oQSBMr9XJPCFUq9bjr267Tb8UFa4wFNjMihP1nP0zDc9VRMw==
X-Received: by 2002:a37:7cf:: with SMTP id 198mr15094454qkh.173.1552067941484;
        Fri, 08 Mar 2019 09:59:01 -0800 (PST)
Received: from localhost ([2620:0:1004:1100:cca9:fccc:8667:9bdc])
        by smtp.gmail.com with ESMTPSA id j17sm2061239qtj.61.2019.03.08.09.59.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 09:59:00 -0800 (PST)
Date:   Fri, 8 Mar 2019 12:58:59 -0500
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        atish patra <atishp04@gmail.com>,
        Daniel Colascione <dancol@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Kees Cook <keescook@chromium.org>,
        Android Kernel Team <kernel-team@android.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Manoj Rao <linux@manojrajarao.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Qais Yousef <qais.yousef@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Shuah Khan <shuah@kernel.org>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH v4 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
Message-ID: <20190308175859.GA61742@google.com>
References: <20190301160856.129678-1-joel@joelfernandes.org>
 <CAMuHMdU77UyUs-LvRx-NN_k0Y7MZXQkBdgL2i83veCkvdzeeqA@mail.gmail.com>
 <20190307150343.GB258852@google.com>
 <CAMuHMdW_7BTZREsnz7uMTToCZ4HDOZboMJH8k8UZica2pB=Jew@mail.gmail.com>
 <CAEXW_YQUcA+bnav20tAFQPXYE=epMie4X85diudKs_s-TJ7dsw@mail.gmail.com>
 <20190308140251.GC25768@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190308140251.GC25768@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Mar 08, 2019 at 03:02:51PM +0100, Greg KH wrote:
> On Fri, Mar 08, 2019 at 05:42:32AM -0800, Joel Fernandes wrote:
> > HI Geert,
> > 
> > On Fri, Mar 8, 2019, 3:53 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > > It is just so much easier to use tar + xz at build time, and leave the
> > > > decompression task to the user. After decompression, the files will live on
> > > > the disk and the page-cache mechanism will free memory when/if the files fall
> > > > off the LRUs.
> > >
> > > I'm also considering how generic and extensible the solution is.
> > > What if people need other build artifacts in the future (e.g. signing key to
> > > load signed modules)?
> > 
> > That sounds like it could be useful. I don't see any reason off the
> > top why that would not be possible to add to the list of archived
> > files in the future. The patch allows populating the list of files
> > from Kbuild using ikh_file_list variable.
> 
> Um, no, you don't want the signing key in the kernel itself, as that
> totally defeats the purpose of the signing key :)

*Bangs self to desk*. You are right, didn't think that one through ;)

By the way, my v5 is ready to send. But I am avoiding sending it due to the
merge window going on. I posted it yesterday in this thread as well:
https://lore.kernel.org/patchwork/comment/1241077/

This is likely to be the final version or so, unless Masahiro or you or other
reviewers have any more comments.

thanks,

 - Joel

