Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A918C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Feb 2022 04:15:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240107AbiBNEP6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 13 Feb 2022 23:15:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbiBNEP6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 13 Feb 2022 23:15:58 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819574EF6A
        for <linux-trace-devel@vger.kernel.org>; Sun, 13 Feb 2022 20:15:51 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id m7so13389755pjk.0
        for <linux-trace-devel@vger.kernel.org>; Sun, 13 Feb 2022 20:15:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zECZXJ/QatDW0vC5aZcaVGT21AwWcmTMDQ1O3h5LEsY=;
        b=MpbVr607eLLB+KzoQoKZ0osibibuyq/vp3m+hK6yfy2ZTbvcnT0lm5NTY9HB1TvMUq
         Lnh9iYk0hVbaXPgarBnSttbw/xhImJAagGGgCZbmySw4wim5mSPxZiz3Pyejtyd/bCF9
         nfoVgFwvfWwnPXr2bWYowbNTvNkm6oqapl+8w42GwkLoy2KqAeibtw4T2I3dr6k7bggR
         2tpsAnDJFHPONcUV5O9mvQopkPxA72Cm8ydc//QkZVT9kjwXxUJn7DTjNdK3BkvAJCY2
         vKndEa7o/9Vg2Fsj0nrxj+HY+dFDGobqPeV7Wu9+9UTCfvZV3G6DI98wzYvMq0cD8iGz
         d5aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zECZXJ/QatDW0vC5aZcaVGT21AwWcmTMDQ1O3h5LEsY=;
        b=WzfdkgFIj4NlGmh9ZJPKPGgfHRqnyO0n1k4gj1GCRcVaFIHRYYx95oc+ZMPy2G1O8U
         3zTArh3Oj9WyUSmXymds3WedX6qEWO67PLULbRiMOHJo3uXk6pCWSF9A4JQWGCDXPk2Z
         npPPqKhFNzJCLQDGMQhjyvo9eGT8xTTnamYTU/F2KKlEywucGtWiKou07m21pHOBFJDx
         SzReR4We5t0SV48byfbvJQJcDvwCOplCk2Kd77D5io9A1oCnUnNolSk/DNMuAbfSuCjd
         HjBDyF6keRn3anI8hqgb0e3ZH69yov4fLknlQWBHRwnEvfQFW5xB9msO1GbOV0/MSpxB
         uBpA==
X-Gm-Message-State: AOAM530KZgzXDdSSuzrNTI4GatzsvorCS7hLa4+dPSAyEZg/M8U/7gfI
        0sJj+Zs3e2rqEFeFQhAprq6xzE1SCo3wiq8l7byBWBGR
X-Google-Smtp-Source: ABdhPJyWnZmr7oiKoYkXbjmlh8IqxUi709RzuRkBdINwgCU+hzvCYq2lQMfMrFJQthkM9Z7HdOMAqXIBdLbpAlk1is8=
X-Received: by 2002:a17:903:1212:: with SMTP id l18mr12330526plh.45.1644812150936;
 Sun, 13 Feb 2022 20:15:50 -0800 (PST)
MIME-Version: 1.0
References: <20220114105748.46761-1-tz.stoyanov@gmail.com> <20220211215639.2bdffbee@rorschach.local.home>
In-Reply-To: <20220211215639.2bdffbee@rorschach.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 14 Feb 2022 06:15:34 +0200
Message-ID: <CAPpZLN68A6Nru=9P1K=z4jD-5wP5JbZwBpE5f33aP6REqeR7tQ@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd reset: Clear all dynamic events
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, Feb 12, 2022 at 4:56 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 14 Jan 2022 12:57:48 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > +     /* Clear event probes first, as they may be attached to other dynamic event */
> > +     tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_EPROBE, true);
> > +     tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_KPROBE |
> > +                                  TRACEFS_DYNEVENT_KRETPROBE |
> > +                                  TRACEFS_DYNEVENT_UPROBE |
> > +                                  TRACEFS_DYNEVENT_URETPROBE |
> > +                                  TRACEFS_DYNEVENT_SYNTH,
> > +                                  true);
> >  }
>
> I accepted this patch, but really, tracefs needs something to define:
>
>         TRACEFS_DYNEVENT_ALL
>
> as callers should not have to call out each type of dynamic event.
> Especially when we are about to add new dynamic events, causing this to
> break again.
>
> Want to add that?
>

Sure, I'll send a patch with that.
Thanks!


> Thanks Tzvetomir,
>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
