Return-Path: <SRS0=eAkL=SL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2FE7C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Apr 2019 15:11:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6EC32084C
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Apr 2019 15:11:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="IIWGAI8T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbfDIPLa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 11:11:30 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36664 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbfDIPLa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 11:11:30 -0400
Received: by mail-pl1-f196.google.com with SMTP id ck15so9580476plb.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 09 Apr 2019 08:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=q+hdpo5Zvt5UX4cGtmri23OHl9BRrTvopODJHtXjDgk=;
        b=IIWGAI8Tpah7LSCb8Uj6j7Bsh2scU7rdBBPG5pGd3vcPJCZX2vKAt4rBqlYJGXPJF7
         KGM7Fcc4D7VbymCdAf4UzE81kvxodO5KmXaG6HiWQ9oUIxP96In7jXi1LS67vdT8uOHL
         NHfid0fMOS+z8idpVwxIOtNNC/Z+0Yhi06NQM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=q+hdpo5Zvt5UX4cGtmri23OHl9BRrTvopODJHtXjDgk=;
        b=M55HRkbSuTHXW/wiLdcSah0R+QW4uLAGn+kRMQlxmisjJAa7M7ecGJUoTHyRTbLCdX
         I09dpo5ZMzd2KNwI8H6iOOdq8bh+fO/qqNaONnrcdAqagLzvU2vc/Oa7h049GEj6JUmU
         rXREzmx9qkF0UpanVx+qsSxQO2j6FAT8Gp0uxR/FkPT5Y8yVAjCdNgo7oeqq3mErCM5J
         C89yzegpH7ZsEHt/q2qvy1LYeCfgd7byhDo+t0tTVoi/Ru+tNQ7tM/tUiNChzUqTeCsE
         pfmBwKIKTb7tOBLTrE6rxE4b8ykRPpP+fbTJJ1ly1U2oGr+7EEl8rW8+5dghB2Ju9dBS
         9WVA==
X-Gm-Message-State: APjAAAU/gARWDOyyCFBxoTzGgJdhCgr26F07GzLPHXbsxmBk552UKlqu
        d10/Ucz6dltXZBe+V/dXyixCcw==
X-Google-Smtp-Source: APXvYqzzYFaDAbXhfHc4LIgX/OHmUWO3xACamq4l9xl/oMgbF/dWI+EUrT2t/BZLaVzxnYk+Cr7TSA==
X-Received: by 2002:a17:902:9006:: with SMTP id a6mr36674982plp.259.1554822689395;
        Tue, 09 Apr 2019 08:11:29 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id g4sm58108236pfm.115.2019.04.09.08.11.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 09 Apr 2019 08:11:28 -0700 (PDT)
Date:   Tue, 9 Apr 2019 11:11:27 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Qais Yousef <qais.yousef@arm.com>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, ast@kernel.org,
        atishp04@gmail.com, dancol@google.com,
        Dan Williams <dan.j.williams@intel.com>,
        dietmar.eggemann@arm.com, gregkh@linuxfoundation.org,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>, karim.yaghmour@opersys.com,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-trace-devel@vger.kernel.org,
        Manoj Rao <linux@manojrajarao.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        mhiramat@kernel.org, rdunlap@infradead.org, rostedt@goodmis.org,
        Shuah Khan <shuah@kernel.org>, yhs@fb.com
Subject: Re: [PATCH v6 1/2] Provide in-kernel headers to make extending
 kernel easier
Message-ID: <20190409151127.GA248418@google.com>
References: <20190408212855.233198-1-joel@joelfernandes.org>
 <20190409150034.qkeceveap4tblk25@e107158-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190409150034.qkeceveap4tblk25@e107158-lin.cambridge.arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Apr 09, 2019 at 04:00:34PM +0100, Qais Yousef wrote:
> On 04/08/19 17:28, Joel Fernandes (Google) wrote:
> > Introduce in-kernel headers which are made available as an archive
> > through proc (/proc/kheaders.tar.xz file). This archive makes it
> > possible to run eBPF and other tracing programs tracing programs that
> > need to extend the kernel for tracing purposes without any dependency on
> > the file system having headers.
> > 
> > On Android and embedded systems, it is common to switch kernels but not
> > have kernel headers available on the file system. Further once a
> > different kernel is booted, any headers stored on the file system will
> > no longer be useful. By storing the headers as a compressed archive
> > within the kernel, we can avoid these issues that have been a hindrance
> > for a long time.
> > 
> > The best way to use this feature is by building it in. Several users
> > have a need for this, when they switch debug kernels, they donot want to
> > update the filesystem or worry about it where to store the headers on
> > it. However, the feature is also buildable as a module in case the user
> > desires it not being part of the kernel image. This makes it possible to
> > load and unload the headers from memory on demand. A tracing program, or
> > a kernel module builder can load the module, do its operations, and then
> > unload the module to save kernel memory. The total memory needed is 3.8MB.
> > 
> > By having the archive available at a fixed location independent of
> > filesystem dependencies and conventions, all debugging tools can
> > directly refer to the fixed location for the archive, without concerning
> > with where the headers on a typical filesystem which significantly
> > simplifies tooling that needs kernel headers.
> > 
> > The code to read the headers is based on /proc/config.gz code and uses
> > the same technique to embed the headers.
> > 
> > IKHD_ST and IKHD_ED markers as is to facilitate future patches that
> > would extract the headers from a kernel or module image.
> > 
> > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> 
> I applied both patches on 5.1-rc2 and managed to compile and run several
> eBPF programs using the untarred headers from /proc/kheaders.tar.xz on my juno.
> 
> Tested-by: Qais Yousef <qais.yousef@arm.com>

Thank you Qais!  Masahiro, if Ok with you now could you give your tag?

thanks,

 - Joel


> > ---
> > 
> >     v5 -> v6: (Masahiro Yamada suggestions mostly)
> >     - Dropped support for module building.
> >     - Rebuild archive if script changes.
> >     - Move archive file list to script.
> >     - Move build script to kernel directory.
> > 
> >     v4 -> v5:
> >     (v4 was Tested-by the following folks)
> >         Tested-by: qais.yousef@arm.com
> >         Tested-by: dietmar.eggemann@arm.com
> >         Tested-by: linux@manojrajarao.com
> 
> Thanks!
> 
> --
> Qais Yousef
