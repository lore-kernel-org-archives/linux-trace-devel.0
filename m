Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 994E0C6379F
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Jan 2023 19:43:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236909AbjAITnI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 9 Jan 2023 14:43:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237525AbjAITmk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 9 Jan 2023 14:42:40 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8D53D9C6
        for <linux-trace-devel@vger.kernel.org>; Mon,  9 Jan 2023 11:42:40 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id y18-20020a0568301d9200b0067082cd4679so5758113oti.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 09 Jan 2023 11:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qO1lQxcR+siw6FrEwDj2nE29u9+gK9rob/TbOT71poI=;
        b=WJTPP7QlEo1fwthZgtkeFlIC27TNvHu4tTBAOmKS/lA7caYpwQ/c54JG7xyh9akQc2
         Ip8uShUwrRuBGqX9aI4pYoqcxOODNKltNyC3GYJKCgC4hH9x+4AyfLBq09xVeduYr3ty
         JZU2WleSRyYeD0gknt6vp9hCrfB82xMeH/7ddBXe43mMmL8xfABw6D9ARb7AmSXEDu54
         wwoOGMFDyjk/4wG6sPCuas4mskInbcR+SvVunmhgSmIpRpS/Y8gFHAgkThyKQNN2qZKR
         s8dcjPCctTgPqs5ms2ztebuJ+pAQtte6rIE3cJSbSpBDpB1CmWizhlAIbgvah6PGhslU
         XnkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qO1lQxcR+siw6FrEwDj2nE29u9+gK9rob/TbOT71poI=;
        b=iCQJ4yF4XMkplf7OXHegggcLjFGDB9dwhV4iELQ5Kw6dnkvNJhINd9hlhhYMgoIcbZ
         a88ETG+C5yHwFQlsdQ13+hebRmWEu3hREGPIKpzoQYue1a6fVek3WC8IsNQ4o+qk2AuM
         wPHfWdlC4MaMhFX/LL+PBf+luaHU950miWoOgpwu1SRLOwl8DG+qZZEWUTZ1w2HlHPaj
         8RQZ4OvahV7Yy4nHQbbA+8n+MV4FsdmKAjgedLqTOEthhu38vgYEuChLPeBylLs9gHGW
         ujl1dRC04nCYQrplcVNq6E1TYkDx4WsQWDtqpahLb3PhVCoZTa/6jpGW6aoOhKcHOn5i
         TpeQ==
X-Gm-Message-State: AFqh2krLulY7D4PAzAuQ3i5864twvuo0OsvKaEgISSuH+uLUeU8YMtpg
        aNFvjfer/Ah3zDDki8DOXjQnDqQUvBj9Vxpy57AIBk+VbEr/Mg==
X-Google-Smtp-Source: AMrXdXu+JBBATzGcSQql2v1pkRcsvxHen0yTzLEwWFBkt/enTT8avveNupPCrFlb/42/GWKcc1mSdhI2pcDiV+GMG9c=
X-Received: by 2002:a9d:5cc5:0:b0:676:92ca:f7f4 with SMTP id
 r5-20020a9d5cc5000000b0067692caf7f4mr3568069oti.55.1673293359536; Mon, 09 Jan
 2023 11:42:39 -0800 (PST)
MIME-Version: 1.0
References: <20230107010245.1290391-1-raj.khem@gmail.com> <20230109130539.62a15985@gandalf.local.home>
In-Reply-To: <20230109130539.62a15985@gandalf.local.home>
From:   Khem Raj <raj.khem@gmail.com>
Date:   Mon, 9 Jan 2023 11:42:13 -0800
Message-ID: <CAMKF1spKBjcryWCXN9xHJ-n37JSBe+h0Wc6v=Scj_QxKkp0hsg@mail.gmail.com>
Subject: Re: [PATCH] Replace LFS64 interfaces off64_t and lseek64
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Jan 9, 2023 at 10:05 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri,  6 Jan 2023 17:02:45 -0800
> Khem Raj <raj.khem@gmail.com> wrote:
>
> > Musl does not define these interfaces unless -D_LARGEFILE64_SOURCE is
> > defined and that too it is transitional until apps switch to using 64bit
> > off_t. We pass -D_LARGEFILE64_SOURCE in makefiles already therefore
> > original lseek and off_t are already 64bit
>
> I just tested this, and that's not true.

Right, I should have said we are already using 64bit functions. I did
not see it since in yocto
it was already being added by distro settings.
I think we need to add -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE and remove
-D_LARGEFILE64_SOURCE, I can update this in v2.

>
> static void pdie(const char *msg)
> {
>         perror(msg);
>         exit(-1);
> }
>
> int main (int argc, char **argv)
> {
>         off_t off;
>         int fd;
>
>         argv0 = argv[0];
>
>         if (argc < 2)
>                 usage();
>
>         printf("off size = %zd\n", sizeof(off));
>
>         fd = open(argv[1], O_RDONLY);
>         if (fd < 0)
>                 pdie("open");
>         off = lseek(fd, 0, SEEK_END);
>         if (off < 0)
>                 pdie("lseek");
>         printf("offset = %zd\n", off);
>         return 0;
> }
>
> I compiled the above on a 32bit machine with:
>
> $ gcc -D_LARGEFILE64_SOURCE -o lseek lseek.c
> $ ./lseek big-file
>
> Where big-file was 6GBs, and I got this:
>
> off size = 4
> lseek: Value too large for defined data type
>
> The _LARGEFILE64_SOURCE just makes the 64 bit versions available. It does
> not convert the original ones.
>
> >
> > This fixes build with latest musl which has dropped LFS64 interfaces [1]
> >
> > [1] https://git.musl-libc.org/cgit/musl/commit/?id=246f1c811448f37a44b41cd8df8d0ef9736d95f4i
> >
> > Signed-off-by: Khem Raj <raj.khem@gmail.com>
> > ---
>
> What we could do is add something like:
>
> #ifdef MUSL
> # define off64_t off_t
> # define lseek64 lseek
> [..]
> #endif
>
> in one of the headers to make it work with musl.
>
> -- Steve
