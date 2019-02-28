Return-Path: <SRS0=lLCO=RD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68CE6C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 15:37:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35FA22133D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 15:37:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="OKlYpKJq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbfB1Pho (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Feb 2019 10:37:44 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33536 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732769AbfB1Pho (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Feb 2019 10:37:44 -0500
Received: by mail-qt1-f195.google.com with SMTP id z39so24003190qtz.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Feb 2019 07:37:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=v7gzrKezcIwFWzmox7p1htcPZe99ZZKhmzdK3ftXpus=;
        b=OKlYpKJqBw9BHHRrZOSIls+nwj3zlbcFyeg0IPRaw8UdAajO2bE/VBExoW3JxC7IVC
         HvDkVhyqO+nldKK++HWCT0R8ypOljUOTJ2u2/9s6Eh78c2xWDsjvKm0VFqRIvq/Pj9fr
         ef3hjYpwdGW/PDVfWqpTS5/FNimiC0v3bb8NI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=v7gzrKezcIwFWzmox7p1htcPZe99ZZKhmzdK3ftXpus=;
        b=RgPy1I/mnBC1n1L6CmIHaplfOKP9gQn4oBkREeuG85uD0e7HswX+Pd5CWi18qpYRsV
         PgfvcDmNYLSbgqy5BrTFCOvAxup5rIUgZiQ32XeSUuov+T5M4GEZ2Cf6q7MZ8SGXcTTT
         1+Wj2KwrZzjoo2uVnKxb32q1fMKStOQc/BPtUHhnL0tHP91edP6Y4R2O6Vh8Vr/K20d2
         CXfrnyTtTeXf3BtPVW8sDeblumTrf8KbFaUI/wIUCQAaO+OCFfAAYrznAAu7ADhBsJtn
         YyJGivM1n0B4+cjGDe6r5x/w+zHBFm4EQdBirk4MNGqCG2Pl5NPar2dZqXi8X2qruQsz
         +mRQ==
X-Gm-Message-State: APjAAAUGZrYYP4HR0ec27r6B46aOisQRU0cyGudwtWbaEjyLUAFsRE1h
        HSOYET8adVRxnaD7r9w3wHzYbw==
X-Google-Smtp-Source: AHgI3IbkuulTYVsXwFGsAS3HsZKOH6wBXPPpaz3vmYcZDvUCg/xtF+gV84H5QLDoGkuEgyxQVdUpmQ==
X-Received: by 2002:ac8:2d68:: with SMTP id o37mr6487503qta.377.1551368263418;
        Thu, 28 Feb 2019 07:37:43 -0800 (PST)
Received: from localhost ([2620:0:1004:1100:cca9:fccc:8667:9bdc])
        by smtp.gmail.com with ESMTPSA id f189sm8129781qkb.79.2019.02.28.07.37.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Feb 2019 07:37:42 -0800 (PST)
Date:   Thu, 28 Feb 2019 10:37:41 -0500
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, ast@kernel.org,
        atishp04@gmail.com, dancol@google.com,
        Dan Williams <dan.j.williams@intel.com>,
        Guenter Roeck <groeck@chromium.org>,
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
Message-ID: <20190228153741.GA168373@google.com>
References: <20190227193748.132301-1-joel@joelfernandes.org>
 <20190228173444.54403795211d80ba540b61cb@kernel.org>
 <20190228150054.GB156098@google.com>
 <20190228153026.GG8481@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190228153026.GG8481@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Feb 28, 2019 at 04:30:26PM +0100, Greg KH wrote:
> On Thu, Feb 28, 2019 at 10:00:54AM -0500, Joel Fernandes wrote:
> > > Hmm, isn't it easier to add kernel-headers package on Android?
> > 
> > I have already been down that road. In the Android ecosystem, the Android
> > teams only provide a "userspace system image" which goes on the system
> > partition of the flash (and a couple other images are also provided but
> > system is the main one). The system image cannot contain GPL source code.
> 
> Note, that last sentance is not true, it can contain whatever license
> code it wants to, as long as the group doing the distribution abides by
> the license of the code contained in it.
> 
> The split of system and other images has nothing to do with license
> issues, but rather functional requirements.  There _might_ be GPL
> licensed code in the image if it meets a requirement for the proper
> functionality of the system, you never know :)

I am not a lawyer either but I know I tried to convince people to allow
headers (GPL sources) on the system image for this same reason and was told
that is not something allowed (allowed can also mean "people are Ok with").

In any case, it is not practical to provide headers for every kernel version on
the system image and maintain them, it will take up too much space and has to
be periodically packaged. Not to mention that there will be kernel versions
that are booting Android that simply don't have anyone maintaining headers
for. So the proposed solution is an easier path.

thanks,

 - Joel

> 
> thanks,
> 
> greg "not a lawyer but I work with a lot of them all the time" k-h
