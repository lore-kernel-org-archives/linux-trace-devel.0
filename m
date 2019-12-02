Return-Path: <SRS0=ia4w=ZY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1444CC432C0
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Dec 2019 12:41:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D879F20748
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Dec 2019 12:41:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e/VXVsr9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727462AbfLBMl2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 2 Dec 2019 07:41:28 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:39560 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbfLBMl2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 07:41:28 -0500
Received: by mail-ot1-f67.google.com with SMTP id 77so9724040oty.6;
        Mon, 02 Dec 2019 04:41:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v4jccqE55GWOauKr9QrlxYG6hq9cbi6xQqZ+qrqIQtU=;
        b=e/VXVsr9R04p7rr2L8KyP22bNyu1F6kLzFl+N967X4X0EUhKeNAuQOI4d/9URUs7yq
         vQuJW1nmUjm2aqNs440Oyd9DEiTIA711sJ6T2e9PL7fIQmnsxpMYPfHNh6VgW+K8/d+V
         tNIgJuABB/Awxdq5MUGiUqWHnudEcjTBXawdbkGhsNyqLNMiWuG5iqLh5pKSkg+m3ev9
         v6uGUIm1ffsavPKXYR0sN2TlhP4meAwCCnPqibjxybVe2piF1T0gFRDl7s8lGAtfK6RK
         1vULmE13peVsFlFW0Sv4TJMx5fdwHf36/Ldx2KmlgpTo7FLrcftTcpXPZgY864nTbs4M
         dIYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v4jccqE55GWOauKr9QrlxYG6hq9cbi6xQqZ+qrqIQtU=;
        b=pKnAV58376C1Z0M0aquE4y6rK2SZMxd32x0qRvuh3feRrYVulpVdKn08mDJKQbrjf2
         QsO4pkHIaw8sUQRrwtaVpi2SJyYz+iq99Yx/sv6SI6XdPKfXJc+Rh5htz6/fOJcn/+1r
         9ppxkgVhqYL+R2mumip4/Cqt9MRRZ06QaRR/tsAyV2m/O91Z9SOSUy0a7Y+QV6q0bT6f
         XZMsmSLEShsAvBHuuzE+dBLsOVn1WCxBWIc0s3RoA53JkbiQGcGyelEy25Ym7tq0ZGpd
         s/QznPFVqR3FJVT8obBbJNFK46LN8dkab1LDYDItVVfLWrYnab35L2D33KPR6ekWTeSV
         C8nQ==
X-Gm-Message-State: APjAAAWX64I0SnInRDZUhmSrzLBSx5bdHWRAODSIHvUrQpYxcTfLvK6T
        dmfQg/BS7KlrSSxpvyHKWN5j3OD60v7YVlJypkA=
X-Google-Smtp-Source: APXvYqx/XM1fQDIxfkHKS+KMfb9rRjJmqVh0BNi2GgrRwqAT69ugp8xH+QePfbWm5VS96dIm7/TEW5Vpfll/SUilniA=
X-Received: by 2002:a05:6830:1db3:: with SMTP id z19mr22245770oti.152.1575290486057;
 Mon, 02 Dec 2019 04:41:26 -0800 (PST)
MIME-Version: 1.0
References: <20191115113610.21493-1-sudipm.mukherjee@gmail.com>
In-Reply-To: <20191115113610.21493-1-sudipm.mukherjee@gmail.com>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Mon, 2 Dec 2019 12:40:49 +0000
Message-ID: <CADVatmMVcDDys62U31D4zOo4pZ58-YP6O25hAZxNObTTEPpfSg@mail.gmail.com>
Subject: Re: [PATCH 1/2] libtraceevent: fix lib installation
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        arnaldo.melo@gmail.com, Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steve,

On Fri, Nov 15, 2019 at 11:36 AM Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
>
> When we use 'O=' with make to build libtraceevent in a separate folder
> it fails to install libtraceevent.a and libtraceevent.so.1.1.0 with the
> error:
>   INSTALL  /home/sudip/linux/obj-trace/libtraceevent.a
>   INSTALL  /home/sudip/linux/obj-trace/libtraceevent.so.1.1.0
> cp: cannot stat 'libtraceevent.a': No such file or directory
> Makefile:225: recipe for target 'install_lib' failed
> make: *** [install_lib] Error 1
>
> I used the command:
> make O=../../../obj-trace DESTDIR=~/test prefix==/usr  install
>
> It turns out libtraceevent Makefile, even though it builds in a separate
> folder, searches for libtraceevent.a and libtraceevent.so.1.1.0 in its
> source folder.
> So, add the 'OUTPUT' prefix to the source path so that 'make' looks for
> the files in the correct place.
>
> Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
> ---
>  tools/lib/traceevent/Makefile | 1 +

A gentle ping.
I know its the merge window now. But your ack for these two patches will allow
me to start with the debian workflow.

--
Regards
Sudip
