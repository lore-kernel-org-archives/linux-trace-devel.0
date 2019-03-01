Return-Path: <SRS0=1gjG=RE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F80C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Mar 2019 17:22:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 151F820850
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Mar 2019 17:22:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="Le5Ueu53"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388690AbfCARWB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 1 Mar 2019 12:22:01 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42356 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728276AbfCARWB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 1 Mar 2019 12:22:01 -0500
Received: by mail-qt1-f195.google.com with SMTP id u7so19417931qtg.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 01 Mar 2019 09:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=U/9thOjurA+lIRFK0bp+ZG70JtmlEraTbsN+PJD2O9I=;
        b=Le5Ueu53kunQMlXpyqwk2e4kYM6t5IvX9AiUfdGQPxrJ+VxZfmHQWHOJuSdMOPIR34
         PQ6VZS1rE/d5mtizV/jGDXMz0UYRflhcUPSg5ynGCSn8TDqDFvpGOx85DqwQtavqgkFR
         +TzA2XnKhu3cb9avBoiHXkJ4xszJSyLbVco+s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=U/9thOjurA+lIRFK0bp+ZG70JtmlEraTbsN+PJD2O9I=;
        b=BzecrxgJeEwtXAISEk+eOZIQeBARBpjnqjIJmxzjSoU2L5fNujHYUkKwOX6B8A2Rln
         VGfiV2l7aWijD4oZWcIiQ4Ce7trvRCP/9orRnKFk3eC7kaRKgvnD+qj/R6deMcVWMXFi
         Jjehnc+Y11TU4+uvr4UFHE8QJdGSKhmF/+ey4bjOR890iAyWEj6ZC50kvvlfSUhBcd7O
         vlO12aQPwkHcLQPgLtPNtGqYKwYwZrOPck8WJdA8FlEgz08/U1+nbY8eUssBbjajihiW
         N4K2SodBEWkOes0/KSFvrpm1Ds5ZtkS8KbuBEmyjXMVxGJZBXii+F2Aq/Oj4qs7FUa5s
         tJaw==
X-Gm-Message-State: APjAAAX+4Mb+NVojqWKhat5unBoa0u8CbE5KgFVPUGxSzopq+k6Gk3qP
        Kz8KxQHblHahDbsFMcRjbLYXug==
X-Google-Smtp-Source: APXvYqx8qELjvvbvGFW2ax0aQPeF/drI8AnPQBY3nP2jPcGHy8fpGhR7rluWFXj7RpbHZCvxdQ0R2w==
X-Received: by 2002:ac8:2bc1:: with SMTP id n1mr4777281qtn.176.1551460919817;
        Fri, 01 Mar 2019 09:21:59 -0800 (PST)
Received: from localhost ([2620:0:1004:1100:cca9:fccc:8667:9bdc])
        by smtp.gmail.com with ESMTPSA id j139sm12403640qke.26.2019.03.01.09.21.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 01 Mar 2019 09:21:58 -0800 (PST)
Date:   Fri, 1 Mar 2019 12:21:58 -0500
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, ast@kernel.org,
        atishp04@gmail.com, dancol@google.com,
        Dan Williams <dan.j.williams@intel.com>,
        gregkh@linuxfoundation.org, Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>, karim.yaghmour@opersys.com,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-trace-devel@vger.kernel.org,
        Manoj Rao <linux@manojrajarao.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        paulmck@linux.vnet.ibm.com,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        qais.yousef@arm.com, rdunlap@infradead.org, rostedt@goodmis.org,
        Shuah Khan <shuah@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, yhs@fb.com
Subject: Re: [PATCH v3 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
Message-ID: <20190301172158.GB217990@google.com>
References: <20190227193748.132301-1-joel@joelfernandes.org>
 <20190228173444.54403795211d80ba540b61cb@kernel.org>
 <20190228150054.GB156098@google.com>
 <20190301112826.ced40b59fb7e8118fa5b40d6@kernel.org>
 <20190301032611.GA78818@google.com>
 <20190301160309.2ddadeeb4aadbab4cdc88171@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190301160309.2ddadeeb4aadbab4cdc88171@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Mar 01, 2019 at 04:03:09PM +0900, Masami Hiramatsu wrote:
> Hi Joel,
> 
> On Thu, 28 Feb 2019 22:26:11 -0500
> Joel Fernandes <joel@joelfernandes.org> wrote:
> 
> > On Fri, Mar 01, 2019 at 11:28:26AM +0900, Masami Hiramatsu wrote:
[..]
> > There are many usecases for this, I have often run into issues with Linux
> > over the years not only with Android, but other distros, where I boot custom
> > kernels with no linux-headers package. This is quite painful. It is
> > convenient to have it as /proc file since the file is dependent on kernel
> > being booted up and this will work across all Linux distros and systems. I
> > feel that if you can keep an open mind about it, you will see that a lot of
> > people will use this feature if it is accepted and there is a lot of positive
> > feedback in earlier posts of this set.
> 
> I don't complain about having headers for custom boot kernel. I agree with you
> that having kernel headers for debugging is always good. :)
> So google recommends built-in, it is reasonable.

Ok, thanks :)

> > > > > > The code to read the headers is based on /proc/config.gz code and uses
> > > > > > the same technique to embed the headers.
> > > > > > 
> > > > > > To build a module, the below steps have been tested on an x86 machine:
> > > > > > modprobe kheaders
> > > > > > rm -rf $HOME/headers
> > > > > > mkdir -p $HOME/headers
> > > > > > tar -xvf /proc/kheaders.tar.xz -C $HOME/headers >/dev/null
> > > > > > cd my-kernel-module
> > > > > > make -C $HOME/headers M=$(pwd) modules
> > > > > > rmmod kheaders
> > > > > 
> > > > > It seems a bit complex, but no difference from compared with carrying
> > > > > kheaders.tar.gz. I think we would better have a psudo filesystem
> > > > > which can mount this compressed header file directly :) Then it becomes
> > > > > simpler, like
> > > > > 
> > > > > modprobe headerfs
> > > > > mkdir $HOME/headers
> > > > > mount -t headerfs $HOME/headers
> > > > > 
> > > > > And this doesn't consume any disk-space.
> > > > 
> > > > I felt using a compressed tar is really the easiest way because of all the
> > > > tools are already available.
> > > 
> > > As I asked above, if the pure tarball is useful, you can simply ask vendors
> > > to put the header tarball on their vendor directory. I feel making it as
> > > a module is not a right way.
> > 
> > I don't see what is the drawback of making it a module, it makes it well
> > integrated into kernel build and ecosystem. I also didn't see any
> > justification you're providing about why it cannot be a module. If you go
> > through this and earlier threads, a lot of people are Ok with having a module
> > option. And I asked several top kernel maintainers at LPC and many people
> > suggested having it as a module.
> 
> I meant, if we have a tarball, we don't need any operation of loading/unloading
> kmodules. But if we have this as built-in, yes, this would be much easier to
> deploy it to device.
> 
> Anyway, having that option (make it as a module) is not bad. IMHO, that may
> be more complicated than just have a tarball file, but it is a user's choice.
> 
> OK, now I understand it.

Sounds good. :) Just sent out v4.

thanks,

 - Joel

