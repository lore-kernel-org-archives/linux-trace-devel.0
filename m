Return-Path: <SRS0=kv0y=S5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7720AC43219
	for <linux-trace-devel@archiver.kernel.org>; Sat, 27 Apr 2019 13:38:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4996C208C2
	for <linux-trace-devel@archiver.kernel.org>; Sat, 27 Apr 2019 13:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556372331;
	bh=CQcLLq5g0BGJbtU32SVU6f5FrjJ1oFNOfzb5TjWhoQw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=RcVhx25A5k7roNnHhoJXUlMBvqzkacEBl+37VKOPV9kLbXBnRQFBXgrLWqJdXtMQ4
	 POpKY2sO+3E6IQi0mqsGyrNl0Zjf62rvDXXml1Wo0F061+GDt1SP9NPpQzTMz/2fn8
	 4p3HvOnLx8ESZFnCAXSdneB8aCuX/QrUj4zFRPQY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbfD0Nis (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 27 Apr 2019 09:38:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbfD0Nir (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 27 Apr 2019 09:38:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 690622087C;
        Sat, 27 Apr 2019 13:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556372326;
        bh=CQcLLq5g0BGJbtU32SVU6f5FrjJ1oFNOfzb5TjWhoQw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VrSZOaxD3J8Y9bd0i/Ao20cxuGAUkc5xtteQQaQTLR0SqpT+eBj9scMUlWJ7z30Fd
         Cr6LcQyukHusNdWX794WdFdVxxZ/ehgIxOqu8Qt63U4KpulEeRq6zOSISMhciNF/g6
         kJScp46Ejq962tIRsV7hJzVQJWveers8pjTvNflI=
Date:   Sat, 27 Apr 2019 15:38:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Andrew Morton <akpm@linux-foundation.org>, ast@kernel.org,
        atishp04@gmail.com, dancol@google.com,
        Dan Williams <dan.j.williams@intel.com>,
        dietmar.eggemann@arm.com, Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>, karim.yaghmour@opersys.com,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-trace-devel@vger.kernel.org,
        Manoj Rao <linux@manojrajarao.com>, mhiramat@kernel.org,
        qais.yousef@arm.com, rdunlap@infradead.org, rostedt@goodmis.org,
        Shuah Khan <shuah@kernel.org>, yhs@fb.com
Subject: Re: [PATCH v7 resend 1/2] Provide in-kernel headers to make
 extending kernel easier
Message-ID: <20190427133844.GA29366@kroah.com>
References: <20190426190430.172543-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190426190430.172543-1-joel@joelfernandes.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Apr 26, 2019 at 03:04:29PM -0400, Joel Fernandes (Google) wrote:
> Introduce in-kernel headers which are made available as an archive
> through proc (/proc/kheaders.tar.xz file). This archive makes it
> possible to run eBPF and other tracing programs that need to extend the
> kernel for tracing purposes without any dependency on the file system
> having headers.
> 
> A github PR is sent for the corresponding BCC patch at:
> https://github.com/iovisor/bcc/pull/2312
> 
> On Android and embedded systems, it is common to switch kernels but not
> have kernel headers available on the file system. Further once a
> different kernel is booted, any headers stored on the file system will
> no longer be useful. This is an issue even well known to distros.
> By storing the headers as a compressed archive within the kernel, we can
> avoid these issues that have been a hindrance for a long time.
> 
> The best way to use this feature is by building it in. Several users
> have a need for this, when they switch debug kernels, they do not want to
> update the filesystem or worry about it where to store the headers on
> it. However, the feature is also buildable as a module in case the user
> desires it not being part of the kernel image. This makes it possible to
> load and unload the headers from memory on demand. A tracing program can
> load the module, do its operations, and then unload the module to save
> kernel memory. The total memory needed is 3.3MB.
> 
> By having the archive available at a fixed location independent of
> filesystem dependencies and conventions, all debugging tools can
> directly refer to the fixed location for the archive, without concerning
> with where the headers on a typical filesystem which significantly
> simplifies tooling that needs kernel headers.
> 
> The code to read the headers is based on /proc/config.gz code and uses
> the same technique to embed the headers.
> 
> Other approaches were discussed such as having an in-memory mountable
> filesystem, but that has drawbacks such as requiring an in-kernel xz
> decompressor which we don't have today, and requiring usage of 42 MB of
> kernel memory to host the decompressed headers at anytime. Also this
> approach is simpler than such approaches.
> 
> Reviewed-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
