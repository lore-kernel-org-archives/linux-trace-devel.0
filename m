Return-Path: <SRS0=DxZ9=RI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D3DC43381
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Mar 2019 16:27:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A86520657
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Mar 2019 16:27:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="hvmEqbCd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbfCEQ1D (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 5 Mar 2019 11:27:03 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:44240 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbfCEQ1D (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 5 Mar 2019 11:27:03 -0500
Received: by mail-qk1-f194.google.com with SMTP id r21so5073027qkl.11
        for <linux-trace-devel@vger.kernel.org>; Tue, 05 Mar 2019 08:27:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=d/RWTJYqTpuZTyuFKaESBOTYVSFBlzsLQJKVAB32I58=;
        b=hvmEqbCdYzsIqNYNZhPSlod6L2/r1WLETDpIHrXsLekgc9v1El22InXdQfaxdlU6v/
         khZCqUzFW4O/b3Go6GnU9s8Y5OI31FCwvUVUQprsQHxYJPniY4bmNkUN1LOSwm6GkARA
         KzV3HrL5yIAEDapL21jvW8tIpAklee/viHBK8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=d/RWTJYqTpuZTyuFKaESBOTYVSFBlzsLQJKVAB32I58=;
        b=fM+dzGbxh0nrUnnpH063nCTs7za1vKU5OPy7y7RzOVO0YvtmsUEnOH8yl8/eprRf7c
         BHMzfcoIRcKGe6NyLezr5llMYwfZ2vv5tjOLiCqjHvpJjyuWA6jy81/TNKYbq64aKxlf
         LChRdGF8NF9+YgMNvL8vQ3Y8h+2DRdy49FkO8hDZ4pto6CY4MP8r0dNR60WnZWhitlWn
         ByfPkAbqjIdUz9UFRyYv3ZzmtXFvTx3f95WgMVe+bLk5489Y4Bn1B6AZ0k07oIPqHGc8
         HbOJuKBYwoRD+sJ5FzhLfJhidvbeeU6fmWTC03amz7v8yTfojJwxtRZN0er5XRPqdptQ
         GYUA==
X-Gm-Message-State: APjAAAXnmD5nmPY7mqOo0eEcOEMCqjBSBtVWVgniZomGXJRzB/B0ZNnv
        FCTv3+sTP5LDNy8TygMqPhhFhA==
X-Google-Smtp-Source: APXvYqw4rGj9VsJbXrMjYMyf9dK6MwNKmsds+4gEH8EbhNT6/YBj/DaGJvHtB0iYoSFX4uCsxsgrqQ==
X-Received: by 2002:ae9:f112:: with SMTP id k18mr2291507qkg.231.1551803221801;
        Tue, 05 Mar 2019 08:27:01 -0800 (PST)
Received: from localhost ([2620:0:1004:1100:cca9:fccc:8667:9bdc])
        by smtp.gmail.com with ESMTPSA id v26sm5798571qtk.22.2019.03.05.08.27.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 05 Mar 2019 08:27:00 -0800 (PST)
Date:   Tue, 5 Mar 2019 11:27:00 -0500
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
Subject: Re: [PATCH v4 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
Message-ID: <20190305162700.GB78911@google.com>
References: <20190301160856.129678-1-joel@joelfernandes.org>
 <20190304140059.5t2bhq7x27jbiuqx@e107158-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190304140059.5t2bhq7x27jbiuqx@e107158-lin.cambridge.arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Mar 04, 2019 at 02:00:59PM +0000, Qais Yousef wrote:
> On 03/01/19 11:08, Joel Fernandes (Google) wrote:
> > Introduce in-kernel headers and other artifacts which are made available
> > as an archive through proc (/proc/kheaders.tar.xz file). This archive makes
> > it possible to build kernel modules, run eBPF programs, and other
> > tracing programs that need to extend the kernel for tracing purposes
> > without any dependency on the file system having headers and build
> > artifacts.
> > 
> > On Android and embedded systems, it is common to switch kernels but not
> > have kernel headers available on the file system. Raw kernel headers
> > also cannot be copied into the filesystem like they can be on other
> > distros, due to licensing and other issues. There's no linux-headers
> > package on Android. Further once a different kernel is booted, any
> > headers stored on the file system will no longer be useful. By storing
> > the headers as a compressed archive within the kernel, we can avoid these
> > issues that have been a hindrance for a long time.
> > 
> > The feature is also buildable as a module just in case the user desires
> > it not being part of the kernel image. This makes it possible to load
> > and unload the headers on demand. A tracing program, or a kernel module
> > builder can load the module, do its operations, and then unload the
> > module to save kernel memory. The total memory needed is 3.8MB.
> > 
> > The code to read the headers is based on /proc/config.gz code and uses
> > the same technique to embed the headers.
> > 
> > To build a module, the below steps have been tested on an x86 machine:
> > modprobe kheaders
> > rm -rf $HOME/headers
> > mkdir -p $HOME/headers
> > tar -xvf /proc/kheaders.tar.xz -C $HOME/headers >/dev/null
> > cd my-kernel-module
> > make -C $HOME/headers M=$(pwd) modules
> > rmmod kheaders
> > 
> > Additional notes:
> > (1) external modules must be built on the same arch as the host that
> > built vmlinux. This can be done either in a qemu emulated chroot on the
> > target, or natively. This is due to host arch dependency of kernel
> > scripts.
> > 
> > (2)
> > A limitation of module building with this is, since Module.symvers is
> > not available in the archive due to a cyclic dependency with building of
> > the archive into the kernel or module binaries, the modules built using
> > the archive will not contain symbol versioning (modversion). This is
> > usually not an issue since the idea of this patch is to build a kernel
> > module on the fly and load it into the same kernel. An appropriate
> > warning is already printed by the kernel to alert the user of modules
> > not having modversions when built using the archive. For building with
> > modversions, the user can use traditional header packages. For our
> > tracing usecases, we build modules on the fly with this so it is not a
> > concern.
> > 
> > (3) I have left IKHD_ST and IKHD_ED markers as is to facilitate
> > future patches that would extract the headers from a kernel or module
> > image.
> > 
> > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> 
> I could get the headers using this patch in both built-in and modules options.
> 
> You can add my tested-and-reviewed-by: Qais Yousef <qais.yousef@arm.com>
> 
> I am not familiar with running kselftests so didn't get a chance to try the
> next patch.

Thanks a lot for testing! Will repost with the tags soon.

 - Joel

