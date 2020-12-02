Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFDC7C64E7C
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Dec 2020 18:44:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 765E62173E
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Dec 2020 18:44:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729177AbgLBSov (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Dec 2020 13:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729044AbgLBSou (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Dec 2020 13:44:50 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D7BC0613CF
        for <linux-trace-devel@vger.kernel.org>; Wed,  2 Dec 2020 10:44:10 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id i18so3010856ioa.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 02 Dec 2020 10:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dnePO/qcw9TpxvQ1m6O12qBhPD/WX3Ypmqz6KCVZkyI=;
        b=p5iR9azimj03eaUkVrT4m8WS+qQiJ7YwF2d3VYaPQfm27H9IkFkcQFbzF1jNwUMb9c
         DXh8nz31wZObkz9ibEpBj1jjuJLhmnvD4PIQHpxaXwBdBt4a+in8rsfhGYwn6EflHhr0
         GQr1EXdinuD2nF0uao2QHlnW2/5rHO/wOyRR7hue5XV+BYWMi+zrsKqphOTivKuRHInX
         4NV7ULpIaJojZxCgI1BDIYa7784ch/ICM6yXew18si1m3N9uUSORvmdIyPxcdskE5I2v
         H+eFc9vfKd/abFXMnVyFDaTTAqh+FdZ+uQL3Z6l626Jb0tFxjkpu035E1SacK3dqCfab
         Ek/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dnePO/qcw9TpxvQ1m6O12qBhPD/WX3Ypmqz6KCVZkyI=;
        b=lfU2k9UFr5eWhzuLmCNXlNYlY+52PhhUcKCP71+2AybhnEVy0iiavig4ZCOKqtlF13
         zkzIlQcKk7zjGANLrpSYoOwbfeYXmJzSeOkyPa5Gi2Y330UKzoRc3K/puzivxsIJ43PV
         GiQ0ucSNef+Y77KGjht+DXlrxNJ30q7Ihm3WHBva0fEf3aEF1Zg8Ha8MniBw4UpBQi7p
         fdXBCm/20+f7TMNtVaIckOnnksub+vpLGbvbieuiccFIi0fbna6CDCsPt5aK8+2mlcKM
         1J4kqwDDV9T5tHARJkffBSdufXzovEvPM0VLewAOsdQfkXySD05J2cHrK7f3I+qw6eVl
         /T+w==
X-Gm-Message-State: AOAM533+cNNLqFPY8yX/keR+1c/VGoP0sqdJeqganH/E8vk9edIjtgPJ
        GnCWNhO2rn9XgaHNS2gO+70IJ/sx8SZhu+ty0Hk=
X-Google-Smtp-Source: ABdhPJwAIY9wVH54FYK9SRdaDwAAK6Nyprm8KwQLnKDPhBuR36tZhS3ICaC2fP03VFIOHGwFb/IhsCRlCQa5vV25l/g=
X-Received: by 2002:a6b:d117:: with SMTP id l23mr3146337iob.146.1606934649655;
 Wed, 02 Dec 2020 10:44:09 -0800 (PST)
MIME-Version: 1.0
References: <20201202040802.327203-1-tz.stoyanov@gmail.com> <20201202093647.78d861ec@oasis.local.home>
In-Reply-To: <20201202093647.78d861ec@oasis.local.home>
From:   Beniamin Sandu <beniaminsandu@gmail.com>
Date:   Wed, 2 Dec 2020 20:43:58 +0200
Message-ID: <CABQJdOGMr6tbsH=nLeCVJ5sVdDBvg2Ba-wL4d9T7ey50RYZn4Q@mail.gmail.com>
Subject: Re: [PATCH] libtracefs: make it build against musl C library
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hey guys,

Sorry to hijack your thread, my previous replies got bounced back by
the mailing list (although I sent them in Plain Text mode), so just
trying again now to see if it works...

Cheers,
Beni

=C3=8En mie., 2 dec. 2020 la 16:36, Steven Rostedt <rostedt@goodmis.org> a =
scris:
>
> On Wed,  2 Dec 2020 06:08:02 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > From: Beniamin Sandu <beniaminsandu@gmail.com>
> >
> > * add some missing headers and macros
> > * set pthread affinity using pthread_setaffinity_np after creating the =
thread
> > instead of pthread_attr_setaffinity_np (which seems to not be implement=
ed
> > in musl)
> >
> > Tested using https://musl.cc/x86_64-linux-musl-native.tgz
> >
> > Link: https://lore.kernel.org/linux-trace-devel/20201130122755.31000-1-=
beniaminsandu@gmail.com
> >
> > Reviewed-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > Signed-off-by: Beniamin Sandu <beniaminsandu@gmail.com>
> > [ Fixed a whitespace issue ]
> > Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
>
> Tzvetomir,
>
> FYI, when sending patches, even for those you are not the author for,
> you are still required to add a Signed-off-by.
>
> Please add that here, and I can pull it into the libtracefs repo.
>
> Thanks!
>
> -- Steve
>
>
> > ---
> >  include/tracefs-local.h | 12 ++++++++++++
> >  tracefs-events.c        |  1 +
> >  2 files changed, 13 insertions(+)
> >
> > diff --git a/include/tracefs-local.h b/include/tracefs-local.h
> > index 9cc371b..bdbf89e 100644
> > --- a/include/tracefs-local.h
> > +++ b/include/tracefs-local.h
> > @@ -13,4 +13,16 @@ void warning(const char *fmt, ...);
> >  int str_read_file(const char *file, char **buffer);
> >  char *trace_append_file(const char *dir, const char *name);
> >
> > +#ifndef ACCESSPERMS
> > +#define ACCESSPERMS (S_IRWXU|S_IRWXG|S_IRWXO) /* 0777 */
> > +#endif
> > +
> > +#ifndef ALLPERMS
> > +#define ALLPERMS (S_ISUID|S_ISGID|S_ISVTX|S_IRWXU|S_IRWXG|S_IRWXO) /* =
07777 */
> > +#endif
> > +
> > +#ifndef DEFFILEMODE
> > +#define DEFFILEMODE (S_IRUSR|S_IWUSR|S_IRGRP|S_IWGRP|S_IROTH|S_IWOTH) =
/* 0666*/
> > +#endif
> > +
> >  #endif /* _TRACE_FS_LOCAL_H */
> > diff --git a/tracefs-events.c b/tracefs-events.c
> > index ca1d22b..ee45988 100644
> > --- a/tracefs-events.c
> > +++ b/tracefs-events.c
> > @@ -13,6 +13,7 @@
> >  #include <errno.h>
> >  #include <sys/stat.h>
> >  #include <fcntl.h>
> > +#include <limits.h>
> >
> >  #include <traceevent/kbuffer.h>
> >
>
