Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12009C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Nov 2021 16:29:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB63D61058
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Nov 2021 16:29:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbhKJQci (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Nov 2021 11:32:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:39452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229602AbhKJQch (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Nov 2021 11:32:37 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A526A61058;
        Wed, 10 Nov 2021 16:29:49 +0000 (UTC)
Date:   Wed, 10 Nov 2021 11:29:47 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 4/5] kernel-shark: Add 'Requires' to libkshark.pc
Message-ID: <20211110112947.321c7b55@gandalf.local.home>
In-Reply-To: <20211110143747.32833-4-y.karadz@gmail.com>
References: <20211110143747.32833-1-y.karadz@gmail.com>
        <20211110143747.32833-4-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 10 Nov 2021 16:37:46 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> --- a/build/libkshark.pc.cmake
> +++ b/build/libkshark.pc.cmake
> @@ -6,5 +6,7 @@ Name: libkshark
>  URL: https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/
>  Description: Library for accessing ftrace file system
>  Version: @KS_VERSION_STRING@
> +Requires: tracecmd >= @LIBTRACECMD_MIN_VERSION@

Note, when I added this, I get:

  # pkg-config --libs libkshark
  Package tracecmd was not found in the pkg-config search path.
  Perhaps you should add the directory containing `tracecmd.pc'
  to the PKG_CONFIG_PATH environment variable
  Package 'tracecmd', required by 'libkshark', not found

But if I switch it to libtracecmd, I get:

  # pkg-config --libs libkshark
  -lkshark -ltracecmd -ltracefs -ltraceevent 

-- Steve

> +Requires: json-c
>  Cflags: -I${includedir}
>  Libs: -L${libdir} -lkshark
> -- 

