Return-Path: <SRS0=uy/X=6E=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 989FDC54FCC
	for <linux-trace-devel@archiver.kernel.org>; Mon, 20 Apr 2020 22:37:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F90620857
	for <linux-trace-devel@archiver.kernel.org>; Mon, 20 Apr 2020 22:37:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EMy2MfNE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbgDTWhy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 20 Apr 2020 18:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgDTWhx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 20 Apr 2020 18:37:53 -0400
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD87C061A0C
        for <linux-trace-devel@vger.kernel.org>; Mon, 20 Apr 2020 15:37:53 -0700 (PDT)
Received: by mail-oo1-xc43.google.com with SMTP id p67so2499964ooa.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 20 Apr 2020 15:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=skGVz5zbZ6bicpKHwk2FUIJ77V2Sgg4crQPymXFpzvM=;
        b=EMy2MfNEQ+tvMMTHdetvo8lpkR5e1iqOGigoh9KboYsNjD8agWFudM8p5O9DauqCis
         9/EK/fxkShjFtBFbbzXj+67aIsDVp+H1DEWP7LloICXF1Q8OkpGehxb0UIbSesu7KurE
         zTcwReU3EgCVhjaNyejE3Wt9/JfoIbWw3J03TleZBxbC5H0DLXN+CJ6E72toLlzHnO2H
         7qt4wA/5GtSdenmZBjmPRk1No5BZiN4xTitm6pO06qJr1pVIlvUNGQgNWr3N9eOVPFBT
         qzKnsSplCB2fqM9kQ2ugkCYrVzM0bduEj+MNMYTe19W3D0RQaTES+LKCx6K6T8ze5jXY
         LD/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=skGVz5zbZ6bicpKHwk2FUIJ77V2Sgg4crQPymXFpzvM=;
        b=CzaIBzEwy00R6cI5l52YRChmBtnC05FTOFut7br8wo1IEfK02QpYvbNO3YV4/oFd+T
         MIGWH8v0pnXa0+uWWIgu1DojfqZdmX4oJ7LUfvpWXeFk0vCQVNF6V3GZ/del+HAEDZDL
         vrgQo8Tc1Wu35eIHIFMDbyhw8OVoH3pioCqPFsGsVahDGuCx1dHHUcFg+oOHiZqZDxMm
         Ug2tpU1FVEZh7nT5+j2zJwyJ3u9SVC2kNMyx/0KPOMt2y6evIbcgawgwTt0LevCixReh
         O1cEBP5zWbPqhMSTj0ClOMJ+xGgPW0zfR/lAi2galMYT046qc2uhL0f47OVqedgnondY
         MFcg==
X-Gm-Message-State: AGi0PuaW4TbHXaF2S0bqvrm1ia8NVfJt7n/Da8X86g3qr3X+4j1WhEj6
        zZkXv9W1UFT8G3jnxWyHAsNM727oah5+Ic68ic+cjq2r
X-Google-Smtp-Source: APiQypLP0JsrfQIlBICiH6dNbr6cYTCTHgQIHVyfyQwtzCWO5B2I4vDZYJtOQMIXRYWKDpdjgIOauLMJVlyrQHWDDzg=
X-Received: by 2002:a4a:ba0b:: with SMTP id b11mr12810546oop.44.1587422273056;
 Mon, 20 Apr 2020 15:37:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200417203914.26358-1-sudipm.mukherjee@gmail.com>
 <20200420154325.6072d96b@gandalf.local.home> <20200420155320.55d3c3f2@gandalf.local.home>
In-Reply-To: <20200420155320.55d3c3f2@gandalf.local.home>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Mon, 20 Apr 2020 23:37:17 +0100
Message-ID: <CADVatmN4Xv00=VvWma9kRwYhsX=jzFn3t8052y1o54srEt6LfQ@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: Fix build with gcc-10
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Apr 20, 2020 at 8:53 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon, 20 Apr 2020 15:43:25 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > On Fri, 17 Apr 2020 21:39:14 +0100
> > Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
> >
> > > The build fails while building with gcc-10 with the error:
> > > multiple definition of `common_type_field'
> >
<snip>
>
> OK, I'll take this patch, and may even enable a -fno-common to find other
> cases of this without having to wait till my distro adds gcc 10 by default.

Thanks Steve. We have gcc-10 in the experimental release of Debian and
I am using that to build. Looks like this was the only one case which
gcc found.


-- 
Regards
Sudip
