Return-Path: <SRS0=GfdA=4P=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B0B2C4BA24
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Feb 2020 09:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2AE12467F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Feb 2020 09:39:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NHXxvAVq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbgB0Jjv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Feb 2020 04:39:51 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35175 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728454AbgB0Jjv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Feb 2020 04:39:51 -0500
Received: by mail-pf1-f196.google.com with SMTP id i19so1343107pfa.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Feb 2020 01:39:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uwBvMUR48yO8+qJ6/mYFh1jwgL2sEiQkHImWBcJxtwA=;
        b=NHXxvAVq7+l0oupo6X5t9B9uJTkyqnvj2i8xWBVuSWTRfQ1KtMzu9umzs7xqVgAiS3
         0TEu6K+zF2R5k1ksljJcBIv7X2izfpEsR1NS9J73T2oPiZHwCUTjvq4LqBy1JLC3u88V
         OkYb1ZxBERcPY4WovStnb0SL092ifYpF+C0ngFeVmeGHAS0WYb3yKhT0nwZi9rdQwQpc
         7fj59+oiMSFTFY08Fm1jIRx8AzNN7Qzb4DIwG/Hl1oRYI7p2dcHL34+J0kjAfurfYHai
         WObB9c29Hd1vBmm74khkGY3q62MdpvWe30V57pVPj4+Pg5vqPGbBr4BXe0rIqtDTzCe4
         5vWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uwBvMUR48yO8+qJ6/mYFh1jwgL2sEiQkHImWBcJxtwA=;
        b=g+stJ/NzVZxaa0BHP70ZevtNfBg7mRgh/SN8WnwLwCWgBrhi4zhAtJLhbDkUpxnM+7
         93KZoV699nqKoCDhjuLf458hDw6Ca3NemHBoz4Rgr1QzD4PaTp5eg//e8ucDcnBeUi3I
         9XxJzTv+g6fhH6JHblFXvTj5V0AM7UZhxOvxhPSvgUQxX752EM5dva0NpQUkpoqAUEGC
         /n05kxTAlHRu29CsM5U2Kp3hfeGW9Z1Q9llMSfiqXfeDW+ZdIWyeR/puF/xuAUniRUZn
         Yxc79JLjH8mDpRgrNyAFoPe20I3f0jJ2gOf/8pgG97Sg3NcXfLaa1/BfhLyL8YIXsF0V
         d6dw==
X-Gm-Message-State: APjAAAW3oUT+vD1N78ielzPqkvhBET9pw0dKn6mqGnRbJDzD/oXvo1vq
        9rEu1ST4Yy5Jv/T5h6Co/6Gv0YH+n9UE/3Nj0SsVIrr3
X-Google-Smtp-Source: APXvYqwYlrAvwZVOljqQWQUboV7yWViWEWWIaarT5LV50BwX4Orvb4dFRByNcIfcVsYKIzrw6UxPFbYJqK36PuCDdKg=
X-Received: by 2002:a63:30c2:: with SMTP id w185mr3366227pgw.307.1582796390564;
 Thu, 27 Feb 2020 01:39:50 -0800 (PST)
MIME-Version: 1.0
References: <20200131121111.130355-1-tz.stoyanov@gmail.com>
 <20200131121111.130355-11-tz.stoyanov@gmail.com> <20200226225613.08a0c7bd@oasis.local.home>
In-Reply-To: <20200226225613.08a0c7bd@oasis.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 27 Feb 2020 11:39:39 +0200
Message-ID: <CAPpZLN7f7xQqbJ5p8X0C4_c5ZUK639ggp1u06JJ88PsBiE2BRw@mail.gmail.com>
Subject: Re: [PATCH v19 10/15] trace-cmd: Add guest information in host's
 trace.dat file
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Feb 27, 2020 at 5:56 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 31 Jan 2020 14:11:06 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > +static int trace_guest_load(struct tracecmd_input *handle, char *buf, int size)
> > +{
> > +     struct guest_trace_info *guest = NULL;
> > +     int cpu;
> > +     int i;
> > +
> > +     guest = calloc(1, sizeof(struct guest_trace_info));
> > +     if (!guest)
> > +             goto error;
> > +
> > +     /*
> > +      * Guest name, null terminated string
> > +      * long long (8 bytes) trace-id
> > +      * int (4 bytes) number of guest CPUs
> > +      * array of size number of guest CPUs:
> > +      *      int (4 bytes) Guest CPU id
> > +      *      int (4 bytes) Host PID, running the guest CPU
> > +      */
> > +
> > +     guest->name = strndup(buf, size);
> > +     if (!guest->name)
> > +             goto error;
> > +     buf += strlen(guest->name) + 1;
> > +     size -= strlen(guest->name) + 1;
> > +
> > +     if (size < sizeof(long long))
> > +             goto error;
> > +     guest->trace_id = tep_read_number(handle->pevent, buf, sizeof(long long));
> > +     buf += sizeof(long long);
>
> Don't we need:
>
>         size -= sizeof(long long);
>
> > +
> > +     if (size < sizeof(int))
> > +             goto error;
> > +     guest->vcpu_count = tep_read_number(handle->pevent, buf, sizeof(int));
> > +     buf += sizeof(int);
>
>         size -= sizeof(int);
>
> > +
> > +     guest->cpu_pid = calloc(guest->vcpu_count, sizeof(int));
> > +     if (!guest->cpu_pid)
> > +             goto error;
> > +
> > +     for (i = 0; i < guest->vcpu_count; i++) {
> > +             if (size < 2 * sizeof(int))
> > +                     goto error;
> > +             cpu = tep_read_number(handle->pevent, buf, sizeof(int));
> > +             buf += sizeof(int);
> > +             if (cpu >= guest->vcpu_count)
> > +                     goto error;
> > +             guest->cpu_pid[cpu] = tep_read_number(handle->pevent,
> > +                                                   buf, sizeof(int));
> > +             buf += sizeof(int);
>
>                 size -= 2 * sizeof(int);
>
I'll add them, thanks!

> -- Steve
>
> > +     }
> > +
> > +     guest->next = handle->guest;
> > +     handle->guest = guest;
> > +     return 0;
> > +
> > +error:
> > +     if (guest) {
> > +             free(guest->cpu_pid);
> > +             free(guest->name);
> > +             free(guest);
> > +     }
> > +     return -1;
> > +}
> > +



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
