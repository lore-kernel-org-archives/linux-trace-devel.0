Return-Path: <SRS0=WSgK=RP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98D54C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Mar 2019 01:45:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CC27214AE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Mar 2019 01:45:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eiuA49yf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbfCLBpc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 21:45:32 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34030 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbfCLBpb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 21:45:31 -0400
Received: by mail-pf1-f195.google.com with SMTP id u9so615011pfn.1;
        Mon, 11 Mar 2019 18:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TfkFOI9Syjr0HfQxSUDH8FDRCp9ri4E/0CE66t2/jTs=;
        b=eiuA49yf4iOB/MdhyItJu1hP8sM7PPoPi67M77GHGuIAUWisGp7zWOusep9INVq8Wv
         OxuVW+OIAbCdb+YTQ2KdYmtpemFmDFolx0bA3N2dpKYFRiw872+gUG+GkjAOXwS8aLeC
         FWIeFKkD60zsYB8AQ7j7ZGDfAtCMudu0811IWYgdZtHDhYO2EgFneG4xnm8aIrSOLEXF
         GU8c6zE2falkoT9+YliqDuyhw9HTpX22Jb/MkmZ2RoIz9kCnYAefV8DFX9gwe0xrw4Zd
         Vvknz/FXORMZwi2S1VE0NEagn8/UXBTYVMWI6Y/Bt/ofMG/h+Ix9CVgBNUDty8Erdgdp
         jt/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TfkFOI9Syjr0HfQxSUDH8FDRCp9ri4E/0CE66t2/jTs=;
        b=Xhgz/rsiaZXZa4MdgVzW8oL0KSOP2+g51gPfbGfDpJ1kCW3MLH3tnasdroCW0nvnVs
         kEtQcFvBaNDPITOC+YmAbtd4OwPcsYuZnBltJiq8lihaH2RmbEaH9IUfCaV1vRMutV0/
         D0vuenJGF4Rqr+VYBL1M/XCnTHCbhVJlQYVWeR64BNvKB8RCfX5AE2zo1e5kjnYbzmeE
         r4nBhakPWHCqi5fq9vZkt4akSdxzONSWIWvjNur849klO2be4bPkkyTxBTy5unSH9gX9
         Roc5+9zAJbgkGQBW6U78Uiv9gYmvvUlyYhExbKfYE3MXZzbV2H0M3A3Li5qNrMjDcgzE
         H48g==
X-Gm-Message-State: APjAAAXGjF+Y5J6A84O+U65G1xurxLzdo+CNmcQHC6T68d62YpnX8w4F
        4nnBEL38vTcMRr2QTiiMOmc=
X-Google-Smtp-Source: APXvYqyutmyDjMr9Ok7C144/shMQ+f27dT4fHaKnSIbCHQS0MHn5iPDcPtOKWOKxnEcNQE984TA7Kg==
X-Received: by 2002:a17:902:9a01:: with SMTP id v1mr31774767plp.34.1552355130187;
        Mon, 11 Mar 2019 18:45:30 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::2:263e])
        by smtp.gmail.com with ESMTPSA id b65sm15496395pfm.127.2019.03.11.18.45.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Mar 2019 18:45:29 -0700 (PDT)
Date:   Mon, 11 Mar 2019 18:45:24 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        Daniel Colascione <dancol@google.com>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        atish patra <atishp04@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
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
        Shuah Khan <shuah@kernel.org>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH v4 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
Message-ID: <20190312014522.jfxg3pdav2piuaqs@ast-mbp>
References: <20190309071648.GE3882@kroah.com>
 <CAMuHMdUT+UGt9p2QhOXzAtCUmqy-a8YN-ceDa-0qANJE53pWBA@mail.gmail.com>
 <20190309121141.GA30173@kroah.com>
 <b7296377-9e0c-aed7-61f0-93d24d1ceddd@opersys.com>
 <CAMuHMdV8+XTyGf1ZJ+gMf=zQpzqh3-+b7wgi+gAmXQ6HpUAw3A@mail.gmail.com>
 <3e84e1ef-e266-e983-5874-6c26ac7f38b8@opersys.com>
 <20190311193612.4f09bf11@oasis.local.home>
 <CAKOZuetHG0O-CiO6h5tD7aht_MT70ebwWMMSPkRUHdiM3wVq0Q@mail.gmail.com>
 <20190312003912.GA170478@google.com>
 <20190311212823.60684182@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190311212823.60684182@oasis.local.home>
User-Agent: NeoMutt/20180223
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Mar 11, 2019 at 09:28:23PM -0400, Steven Rostedt wrote:
> On Mon, 11 Mar 2019 20:39:12 -0400
> Joel Fernandes <joel@joelfernandes.org> wrote:
> 
> > I think even though the kernel-headers can't have information about all data
> > structures, they do already contain a lot of data structure definitions we
> > need already. And anything needed can/should arguably be moved to include/ if
> > they are really needed for kernel extension by something "external" to the
> > kernel such as kernel modules or eBPF, right?
> 
> That's not my worry. I would like to be able to easily walk data
> structures from within the kernel, without having to do a lot of work
> in userspace to get that information. The kprobe_events could then be
> passed type casts or such to access data fields of arguments to
> functions and such.
> 
> > 
> > In any case, such a solution such as what Steve suggested, still cannot do
> > what we can with headers - such as build kernel modules on the fly using the
> > C-compiler without any auto-generation of C code from any debug artifiacts.
> > Think systemtap working with the module-backend without any need for
> > linux-headers package on the file system. So such a solution would still be a
> > bit orthogonal in scope to what this proposed solution can solve IMO.
> > 
> 
> With the information I would like to have, it would be trivial to read
> the data to create the header files needed for modules.

what you're asking for we already have. It's called BTF.
pahole takes vmlinux dwarf and convert it into ~1Mbyte of BTF that includes
all kernel types.
With gzip it can be compressed further if necessary.
We also have a prototype to generate all_vmlinux_types.h from BTF.
But it's not a substitute for kernel headers.
We've had a long discussion during last LPC regarding this:
http://vger.kernel.org/lpc-bpf2018.html#session-2
tldr: many tracing use cases will be solved with BTF, but kernel headers
are here to stay.

