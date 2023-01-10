Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0AC9C54EBE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Jan 2023 01:03:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjAJBDv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 9 Jan 2023 20:03:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjAJBDt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 9 Jan 2023 20:03:49 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6913FCB2
        for <linux-trace-devel@vger.kernel.org>; Mon,  9 Jan 2023 17:03:48 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id e17-20020a9d7311000000b00678202573f1so6144499otk.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 09 Jan 2023 17:03:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=u4apy+MtNEUdUXKCUdc2IBXVHM6C8n/eykGfy34MKhc=;
        b=hp+bWaP5oUiHcLKtKDzHR98ZjPFFVk+deCzl6XiJ58q04ESPbxxqioXmaj3hI3tMEp
         yU/1FU6jCD+03ctzbXu38afEmVcLvwrZz07thrFJ/sAaQLrPjcyzvZ6aE4L62LDsQfMv
         eKkEPXlwCAx+ehPsa2SJp2lzxC6C/1GvOHqvuthBuwQD7m8xsZ3hnuV3aXx5j2TN2WMU
         DKfvGhAS/+Nnai8Ct8J5mbNLPrN/nFy9ICoS4oGesuL35uS1EwBcX7CaynuaLCdsgzZh
         pXhr6mCjjQnc3tptPaIf4ncFvbeKG3BJQHrK+f9U1s1ppZdjFlf0L6uVUuh+MFwouGUN
         afmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u4apy+MtNEUdUXKCUdc2IBXVHM6C8n/eykGfy34MKhc=;
        b=hpBBsqpUCEXugnJDKyEW1OK9//r2nEfjwjvC9yDA0wYkRFZXt3wDRH8DRBcXWBiZOt
         iKYq4fLICdXktbskCCs6OodQuV5kjajBohusi2OKINy0aGhRMhlpRD7ESEYJdmG5xIqU
         BxlA+PQfnKG/FzzAGJpOsxlnRiorgJ5hjsh6Sm8R9dftwnPkbGbFvqLsld/ftQaliAbD
         6qALoGNTAL5f0r0XMY9ZfAfhOF6NGG+LZJejSstGYy7XuRzYqmptBqsPqc9W0bqjbbew
         Ex1ddOZzs9mxiPHw69tbv53ehJUt9n9HMNi8dhM83Zfm73xnvC9in6sNFXj0AZchsE13
         uYkg==
X-Gm-Message-State: AFqh2kpZyuxedXPXnzy8kXnA/VZ7QkR/elEIKpEfJnG7N5aFHxe5vQG3
        Kh0Hfde1tLvdoBR5xJx6vEV9XJjDqYtFnkTRI3CSu2CwuZ8=
X-Google-Smtp-Source: AMrXdXtNACpK2vNJfL4RntfGaCu10NdbHpVDt6kouR1iUEoh4A44Ixc6pqb5gxHyIgcrAYGO0Rp4Jgwf2iyg1k8jD44=
X-Received: by 2002:a9d:5cc5:0:b0:676:92ca:f7f4 with SMTP id
 r5-20020a9d5cc5000000b0067692caf7f4mr3610807oti.55.1673312627890; Mon, 09 Jan
 2023 17:03:47 -0800 (PST)
MIME-Version: 1.0
References: <20230109225315.1284538-1-raj.khem@gmail.com> <20230109185100.7b0cf697@gandalf.local.home>
In-Reply-To: <20230109185100.7b0cf697@gandalf.local.home>
From:   Khem Raj <raj.khem@gmail.com>
Date:   Mon, 9 Jan 2023 17:03:21 -0800
Message-ID: <CAMKF1sr9Jp97_NrvPuONjFiULHdnz0AJuBGcigJvHQcYe12o4Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] Replace LFS64 interfaces off64_t and lseek64
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Jan 9, 2023 at 3:51 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon,  9 Jan 2023 14:53:14 -0800
> Khem Raj <raj.khem@gmail.com> wrote:
>
> > Musl does not define these interfaces unless -D_LARGEFILE64_SOURCE is
> > defined and that too it is transitional until apps switch to using 64-bit
> > off_t. We pass -D_FILE_OFFSET_BITS=64 in makefiles already therefore
> > original lseek and off_t are already 64bit
> >
> > This fixes build with latest musl which has dropped LFS64 interfaces [1]
> >
> > [1] https://git.musl-libc.org/cgit/musl/commit/?id=246f1c811448f37a44b41cd8df8d0ef9736d95f4i
> >
> > Signed-off-by: Khem Raj <raj.khem@gmail.com>
> > ---
>
> FYI, when submitting patches, please have the subject state the project, as
> the mailing list covers multiple projects, and the subjects are used to
> determine which project its for.
>
> Subject: trace-cmd: Replace LFS64 interfaces off64_t and lseek64
>
> You don't need to resubmit, I can add it, but just for future submissions.
>
Understood. Somehow it did not occur to me my bad :(. will keep in
mind next time.

> Thanks!
>
> -- Steve
