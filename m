Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1EB8C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Dec 2020 16:38:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E2D222288
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Dec 2020 16:38:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbgLXQiO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Dec 2020 11:38:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726746AbgLXQiN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Dec 2020 11:38:13 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 658E3C061573
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Dec 2020 08:37:33 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id f6so2582940ybq.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Dec 2020 08:37:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Ixdk9QMKXmafpbezwUVmQ3pxN0M92fOTt/kdoVbGNiQ=;
        b=TUPH/nbxqH7xYeO81tNivDpS3zeMm3wJpV2DmQgiWn6egBTpe/hs0oOsQQvYfSX8pX
         UXXuyiL1u9v0Cx1SqupCvXccmVqJzibG5qgW170Am9gcC/zT9PEg7YfphcuUbXbGWV/L
         YUWBkoPgEh06NHFm7n+HQxfJQkJ7WPbbuMY0H0BpJ+Qp+F7U2tjm4Hj97pfOKQoq3lXu
         jnRtPFc0mIbfBfrj4YfE9rAKp0C9Kzqf3cX8sIilaGujiVufOMhQnrv8vkW3QAd0QlVo
         UiVr+gWXuhwsbJ61Rmnj9ZS9+ofgaJIqc6oMq+iysiZyi3tarUo67FssJHSyRcQ8YAPn
         fk9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Ixdk9QMKXmafpbezwUVmQ3pxN0M92fOTt/kdoVbGNiQ=;
        b=tZJdUT+J7W/t6wfU0UnH8rBmTWLtVoaJJzF0Sn3HF9gb9jneEOA3SlxHfjM/9LXk3c
         eHOb0Em8OU6oNrF6w+MteLQAIH0yROAnh62W3DHl/ykss/hWK5NRKgia43wYxpbyRSw4
         HPA8rvqDtSJ4yfgw6sIWZ0ajbZ8woeLBVsKnbBWXgtWA0GS+GedN2CI0fAI0NpWEv2rJ
         ov8Zqq+WX9Uga3BLKGLiCh5hUQ43As4PzOfWIGIp9OmyitCxyrzvhMtF3fRmx8i+ouEv
         +Nc6mbpCvP+qI5H7EPv4qx3qTPoHTarVhBaIr9o9lzmSWbVrBq8Bvem1r7BEr0jN9gMK
         HycQ==
X-Gm-Message-State: AOAM532wfk0bbZviQ4aqbUDljJJBCmha/OomDDqry0mAbqpNypaKswWh
        ffa6yAyD7cvXVLr3E9jRXXUiVzep5QjaqEBKEzNW9BM+1X9k5Q==
X-Google-Smtp-Source: ABdhPJzmw8UjLrxW9l2/CXGQPs+VcuJ0RgSDSdefNyneJlbUdjZKZlm8bBl80PDtbaODrinyQR0axgAT0Mf3FC+rP2g=
X-Received: by 2002:a5b:3c8:: with SMTP id t8mr42340089ybp.19.1608827852336;
 Thu, 24 Dec 2020 08:37:32 -0800 (PST)
MIME-Version: 1.0
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Thu, 24 Dec 2020 16:36:56 +0000
Message-ID: <CADVatmNE_Bm6Gv9ArNsTQhJME9y7gbnExFf+iy_=68CSKKZ+Xw@mail.gmail.com>
Subject: libtracefs documentation install problem
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steve,

I was trying to build and install the documentation. "make doc"
succeeds and builds the man pages and the html files, but when I do
"make install_doc" it fails with:
make -C /home/sudip/libtracefs/Documentation install
Makefile:148: *** "You need to install asciidoc xmlto for man pages".  Stop.
make: *** [Makefile:263: install_doc] Error 2

The packages asciidoc and xmlto are already installed and I guess
thats why it could build. Looking at the Documantion makefile I can
see that install-man is checking for the tools by calling
'get-executable' but I did not see 'get-executable' defined anywhere.
Did I miss something or did you miss copying it from
"tools/scripts/utilities.mak" of the kernel ?

I hope I am not disturbing your holidays. :)

-- 
Regards
Sudip
