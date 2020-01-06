Return-Path: <SRS0=UiB3=23=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1745C33C8C
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 20:14:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE5A5208C4
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 20:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578341645;
	bh=IpZ3IzZdaLQjy/WkdZ42lOwZUPP399O8FHW0YHuFwx0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Br2L4Qog+FVXIkJCNe/O+c+k1KJWUAPjNFQNsQH3HWnHSkUb61gv3HJ7zWyP9S0/R
	 MUZBF/cisLpFblLouSELx0BaLbC8I7MpHdfc30fyG4r2ZTon9WWnL0QLclhdEPHrdm
	 DddiutDmuVI9ebMpSFIwxBYfsdN4Z1+sgmCIPnXQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgAFUOF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 15:14:05 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:34673 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbgAFUOF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 15:14:05 -0500
Received: by mail-qv1-f66.google.com with SMTP id o18so19590892qvf.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 06 Jan 2020 12:14:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=zAjSv7QwLnVDNHgBSI40PMyv7BAdw9r1HNnXDMPP2Ok=;
        b=ONQ+uAd6Gf8x5vWcWhtrAXR/SVBEMazn50+msn0BVUrUEHoJQM5rB3xSi9T5au1N69
         tauVhMdhf9e31ZmzdmQ7kVs33UIvDpEOw8+AyX6uNmAet3lk7C8JZk1SiPQNlbxush8u
         ac1+P8ChStqoGgbN8qrnsrVB+SinBC1b1DJLw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=zAjSv7QwLnVDNHgBSI40PMyv7BAdw9r1HNnXDMPP2Ok=;
        b=ppfLXHJQlBBckX62iP9K0bLcV4Mnp5HqR35PWzMtTzbJs/IpetRcoeY6fuLHbrkatO
         1LkujexZFXrh5Y2JcOMhMuMjNhEihYYtUKqNdrYou6EPvQtsv7V9taGQ3wFSf3xWL+LR
         52pxS4AWjWSUv4luV6LBiA0TwkuEOFTIH7ySklipXjagF6CpHOtK2ev9f714sG9ge4im
         9MLbkgGppd9TMupCg6OctIZ7kTWrMEbobz1vV9ANwAxoOdFNMSKcX3HuNsmJMWXsTE+U
         HJqXlqpMFXRWEjkFKaY9ZRTT9DS1p20Y8mwn2il0UtKlCfLrRSJyd9VZWHWAQEJrrDpT
         LyIw==
X-Gm-Message-State: APjAAAUSnMuD0qM5fgWyUhMsI24DRtJqCt3sMrS891PRL9PJiVJBJt7f
        vt3MSKu8hpuA9UvFyUMbPqSlsA==
X-Google-Smtp-Source: APXvYqz5Rna8W9FnlG3nKTkWAbydEX6Ym9Y2Hw+whIFZGHvlEPQtbVeE4vyKKzvT3K/nRUswZDYxZQ==
X-Received: by 2002:a05:6214:b90:: with SMTP id fe16mr81833259qvb.83.1578341643916;
        Mon, 06 Jan 2020 12:14:03 -0800 (PST)
Received: from chatter.i7.local (107-179-243-71.cpe.teksavvy.com. [107.179.243.71])
        by smtp.gmail.com with ESMTPSA id g16sm21278877qkk.61.2020.01.06.12.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2020 12:14:03 -0800 (PST)
Date:   Mon, 6 Jan 2020 15:14:01 -0500
From:   Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>, Jiri Olsa <jolsa@redhat.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        users@linux.kernel.org
Subject: Re: [RFC] tools lib traceevent: How to do library versioning being
 in the Linux kernel source?
Message-ID: <20200106201401.hcneggg4xmoazr5e@chatter.i7.local>
Mail-Followup-To: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Olsa <jolsa@redhat.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        users@linux.kernel.org
References: <20200102122004.216c85da@gandalf.local.home>
 <20200102234950.GA14768@krava>
 <20200102185853.0ed433e4@gandalf.local.home>
 <20200103133640.GD9715@krava>
 <20200103181614.7aa37f6d@gandalf.local.home>
 <20200106151902.GB236146@krava>
 <20200106162623.GA11285@kernel.org>
 <20200106113615.4545e3c5@gandalf.local.home>
 <20200106194711.GC11285@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200106194711.GC11285@kernel.org>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Jan 06, 2020 at 04:47:11PM -0300, Arnaldo Carvalho de Melo wrote:
> Sure, regardless of where you do source code control you will need to
> tag, create a tarball, signatures (which kup helps with) for kernel.org,
> for instance I use:
> 
>   kup put perf-${VER}.tar.xz perf-${VER}.tar.sign /pub/linux/kernel/tools/perf/v${VER}/perf-${VER}.tar.xz

It's worth noting that you don't have to use kup if you don't want to -- 
we have a mechanism to create tarball releases directly from tag 
signatures. You just have to add a special note to the tag and the 
backend does the rest automatically -- we have a handy script [^1] to 
make it easier.

Greg KH has been using this process for a while now.

If you would like to switch to that instead of using kup directly, just 
let me know.

-K

[^1]: https://git.kernel.org/pub/scm/linux/kernel/git/mricon/korg-helpers.git/tree/git-archive-signer
