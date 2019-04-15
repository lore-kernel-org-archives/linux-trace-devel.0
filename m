Return-Path: <SRS0=14DL=SR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B25FC10F0E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 13:52:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B6D62073F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 13:52:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="uws0u/Ik"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfDONwx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 09:52:53 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37950 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727371AbfDONww (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 09:52:52 -0400
Received: by mail-pl1-f196.google.com with SMTP id f36so8611713plb.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Apr 2019 06:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=H0ECi+coMQS790WnImRT1BzjbruprNFYZr4FQCCImBI=;
        b=uws0u/IkNDfeA2aOvTdeHGFjirw9YYE/5u5AUfvNXfVn+H6je/jHQelY8+nZrZuRYq
         eDzLzropG6PNgCzqtC2NsAj+zU3QiYKndfbSXySUYPqD2INxgS6JQUu2oR0IUOFOAYyA
         zRNv5j/L3ZUeLHToSwPIzAPQ9mUMDx9lLnoVU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=H0ECi+coMQS790WnImRT1BzjbruprNFYZr4FQCCImBI=;
        b=VIkIhwBYrPNLgGKGQ36j7d9fXjfMBtjA65yFFuT+Fc0b150cAWdUo4NHyh4DMTZmWY
         GzXYtkjXxjxD4pcjOrWg+qQ1LStQh6mlZTMMyua7Fua6z/jlZ7knR/vkUOPqVMaELLbd
         AghxOvGdhg+uexshHHt3rybEmWjYk+hy3OxllLgZr7ci6xBF3N67qtBgK0sLJytHhl98
         QF7WBo1uRW/CEkcILiwrkS1mgm2U82MmSHrIbVcfomPYZc5ur3d47Y3AyIj0FsbY2XfW
         yNKoWAxUd4t/dQ/Gv5NaB6cD7DA/dUCuI9po8udUZHw9tIaYjb1q2HwENOy5QOXapepR
         bv6Q==
X-Gm-Message-State: APjAAAUoV6YQl8TzJY2Qh4tPIkf8IHtNeKUIQuxU6ogPKVnAgjt8cKl/
        l01XcPBnPnuAWGrq6GYsic+VKQ==
X-Google-Smtp-Source: APXvYqwvMuOFjHGBJpuaBzExILDLa5UZfSiK+loI/oBxsUTx19uI7c1Fo4MI8zNu5pWgfbNvNjowxg==
X-Received: by 2002:a17:902:6b8b:: with SMTP id p11mr51636845plk.225.1555336371864;
        Mon, 15 Apr 2019 06:52:51 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id y12sm118488194pgq.64.2019.04.15.06.52.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Apr 2019 06:52:50 -0700 (PDT)
Date:   Mon, 15 Apr 2019 09:52:49 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Cc:     Olof Johansson <olof@lixom.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Qais Yousef <qais.yousef@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Manoj Rao <linux@manojrajarao.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        atish patra <atishp04@gmail.com>,
        Daniel Colascione <dancol@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Kees Cook <keescook@chromium.org>,
        Android Kernel Team <kernel-team@android.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Shuah Khan <shuah@kernel.org>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH v5 1/3] Provide in-kernel headers to make extending
 kernel easier
Message-ID: <20190415135249.GA205801@google.com>
References: <20190320163116.39275-1-joel@joelfernandes.org>
 <CAOesGMheoZda84OSz9spQ7p66wot5S_9aaqaKC=QYp+8utASXA@mail.gmail.com>
 <20190408203601.GF133872@google.com>
 <CAOesGMibHCuMPCYkc8V++Z2Kuf3YQf_OjYn18GvDgzTy6ubV=g@mail.gmail.com>
 <CAJWu+or0hWce9+7aEfTHoOR8cptRbzHYVL-bPdJWGZH20dbo7Q@mail.gmail.com>
 <CAOesGMiuGK-Sbqo2z=1ab070JONav1LF82MRRLCdX-4+14_XZA@mail.gmail.com>
 <20190411031540.ehezr6kq7ouobpzx@ast-mbp.dhcp.thefacebook.com>
 <CAOesGMgiPB=7FE7tXXHes7WSLfByyPxirOStoH21NZqMwaUihQ@mail.gmail.com>
 <463a08cb-d1ac-b750-c699-8242c2c20fd2@metux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463a08cb-d1ac-b750-c699-8242c2c20fd2@metux.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Apr 15, 2019 at 11:41:18AM +0200, Enrico Weigelt, metux IT consult wrote:
[snip]
> > This patch seems to have been met with a lot of responses in the tone> of "this is not an appealing solution".
> 
> Personally, having generic helpers for putting blobs into /proc files
> (like config.gz) sound appealing. But I'm not sure whether doing that
> w/ kernel headers this way is a good solution. Actually, I'm even not
> sure whether raw kernel headers are at all are a good way. (can't we
> use compiler-generated debug info ?)

We can't use compiler generated debug info for this.

As discussed previously here, eBPF tools need kernel headers, DWARF and
compiler debug information wont help:
https://lkml.org/lkml/2019/3/11/1358
https://lkml.org/lkml/2019/3/11/1363

> > Usually what we do at times like this is that we say "Yeah, this is a> problem that should be solved, but this solution doesn't seem to be>
> the right one and we would need to maintain it forever as part of the>
> ABI. Let's wait until a better solution is found." With time,> sometimes
> a better solution becomes obvious, or circumstances change> enough to
> allow for some different approach, or someone has a new idea> from a
> different perspective that solves the same problem.
> ACK. For now, this is an Android-only debug tool, just needed there
> because of it's unusual partitioning/deployment mechanisms - on usual
> GNU/Linux distros, we just have the kheaders in the file system.
> (and even on my small embedded devices, I either run the DUTs via NFS,
> 9P2k, initrd, etc or just deploy kernel and headers into the filesystem)
> 
> As Android already is in it's own universe, why can't that stuff remain
> incubated there, until we have more field experience w/ it and more time
> to rethink the whole idea very carefully ?

Well, we follow mostly an upstream first process.

> The patch is pretty small, so it's trivial cherry-pick, in case somebody
> outside Android universe wants to use it.

It could break very easily if things upstream change in some way, and adds a
lot of maintenance burden, besides I don't see a good reason it should not be
upstreamed tbh.

thanks,

 - Joel

