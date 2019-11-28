Return-Path: <SRS0=1fLi=ZU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7514EC432C0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 15:06:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A0FB2084D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 15:06:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gR7OGpEC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbfK1PGA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Nov 2019 10:06:00 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33800 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbfK1PF7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Nov 2019 10:05:59 -0500
Received: by mail-pf1-f195.google.com with SMTP id n13so13295462pff.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Nov 2019 07:05:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IIFhKY8MkyIZzu9lXSkabK7FTRKmN9G58bXSG9a6eoU=;
        b=gR7OGpECp3nl5ovZI8FP0K073vFAcs4/2LTc7Uyck3R7dLR9Fv1mt8oaI1OEGeUd2Y
         gtHdf2Av96vHHeCj7GGUeAOCGfNqBGYZ1N3PJdsaf+cvpkcxusnRl98PjxZqRkBuZ7Px
         HnwaJ09LBK6DlCwb9UDYK78J9QWk9j6tMTotKYVmD/MWA+kzyiQf5CkO5+EMyTFSIpzR
         IhMJDm78Tf+3uiPLq/15ddYZAd2DeMo37YEvDdBrlXKZ/8HyvMWMgcFAponpRRnd4zuX
         4Qu9sStLwJlTTMkKV6RePNOKm5+KAbuLyNextR1777MlndZpVS3IukWPm8SpklnyySI3
         Yk9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IIFhKY8MkyIZzu9lXSkabK7FTRKmN9G58bXSG9a6eoU=;
        b=loqVKADKWYhccmHdg5CqUYMXQf9rJ7pTZkfepj6Wz5hLSIinAbkiWov6z82b1C+2Hv
         o5+EFbH9Jmkzhq8gy8NTnpmSJNnbkkUtvRrSY08GFXpdWHRoVrWml+Fcjo7oHms1h+3+
         xgP62j1qcnXTIx7533njcdomjJhrPcO2Om6M/TbjwOBYXymnSIRJQVWASsFrrhqe2kJz
         ExNHgOJTUZNp+jmWcr4mLAvZkXJIeEPYKV7Ep6na+z2sJ0pGly0Y1I8wlhT00FbLBxGB
         4vbFRPyg9ueXq3+kFQx2wym7xr0b5G53U41pANH9QUg2mCeL4JzD/OyQ0JMUyq+/j0qk
         uZpw==
X-Gm-Message-State: APjAAAW58uCp8hSt44S2+QzdezFgQxosvNw9jalh0i03KmQbhUBJViXI
        mhoRnw+w+AzJxo+mTj4RaSPv+KoaM+nrLYlb5uo=
X-Google-Smtp-Source: APXvYqycyLBoQZ9C9p2nw4MDsTmfilo6+OM58turXJQyV2fWRf7B6cazfOWMvbBh2IoodkJkSCDcAFDKHs7WkWA6B9Y=
X-Received: by 2002:a63:1916:: with SMTP id z22mr11678569pgl.206.1574953559106;
 Thu, 28 Nov 2019 07:05:59 -0800 (PST)
MIME-Version: 1.0
References: <20191128085409.289684-1-tz.stoyanov@gmail.com>
 <20191128085409.289684-15-tz.stoyanov@gmail.com> <CAE0o1NvU+112Y-HkurJZHKj0ARW3mJvEquF6aB39KLkcnNkrQA@mail.gmail.com>
In-Reply-To: <CAE0o1NvU+112Y-HkurJZHKj0ARW3mJvEquF6aB39KLkcnNkrQA@mail.gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 28 Nov 2019 17:05:47 +0200
Message-ID: <CAPpZLN63P=dc2ROsBPK6x=um8z8N3FML3T01kV7VzoVqsQgoFw@mail.gmail.com>
Subject: Re: [PATCH v15 14/18] trace-cmd: Add host trace clock as guest trace argument
To:     Slavomir Kaslev <slavomir.kaslev@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Nov 28, 2019 at 4:45 PM Slavomir Kaslev
<slavomir.kaslev@gmail.com> wrote:
>
 ...
> > +       struct buffer_instance *instance;
> > +       bool guest_config = false;
>
> guest_config is a bit vague of a name for what it's used here. Maybe
> has_clock_arg?
>
The same flag is used for similar host config, which is applied to
guests - in the following patches from the series.

> >
> >         init_common_record_context(ctx, curr_cmd);
> >
 ...
> > +       if (guest_config) {
> > +               /* If -C is specified, prepend clock to all guest VM flags */
> > +               for_all_instances(instance) {
> > +                       if (top_instance.ftrace->clock) {
> > +                               if (is_guest(instance)) {
> > +                                       add_argv(instance,
> > +                                                (char *)top_instance.ftrace->clock,
> > +                                                true);
> > +                                       add_argv(instance, "-C", true);
>
> Shouldn't those two add_arvgv() calls be swapped?
It is a little bit confusing, add_argv() actually prepends the
arguments - so the last call puts the first argument in the list.
The user specified arguments are always after those. When the args are
parsed in the guest, in case of duplication, the last one wins.

>
> > +                               }
> > +                       }
> > +               }
> > +       }
> > +
> >         if (!ctx->filtered && ctx->instance->filter_mod)
> >                 add_func(&ctx->instance->filter_funcs,
> >                          ctx->instance->filter_mod, "*");
> > --
> > 2.23.0
> >
>
> Cheers,
>
> -- Slavi

-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
