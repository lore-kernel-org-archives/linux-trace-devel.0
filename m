Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE906C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 May 2022 13:39:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236323AbiEWNj7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 23 May 2022 09:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236295AbiEWNj6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 23 May 2022 09:39:58 -0400
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E61D40E7D
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 May 2022 06:39:57 -0700 (PDT)
Received: by mail-oo1-xc35.google.com with SMTP id s4-20020a4ac804000000b0040e93a35508so279438ooq.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 May 2022 06:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qVT8S6li2syJt2/nbaWPBKrgHixkjbNBL2xOtiUcH3E=;
        b=Fd6dfBZz0KwGHrjF+R5kD/KfV7NwEcyQPLC0oMWd8zqAtZuDPD22LsEZuy1xDJPijW
         ZdWRLqhTnKFGnL1zjE77Cq9zE3pM147/jyHI+v9Rglsk/VGaj0oqCF7/y6Z2LKCD3jVx
         2iNccvuNYLDEL7p8AhKC76yqWhE4bFXINTbRtVRbFCWaSpUxCXM4N9CGJtjfCWdn18YD
         s4pPB6zjSr2fXbPlF4ZAbAsTPLOoSGfX3aNXSGePZY/eoC9vlPiLziOihR0V2K5CdUJU
         uxB3r94yzq2RuDdeMAtFV7PY67BIiXIDAPq+Da6/BIDlFeq+1Kko62Oc7jsmYR7U/Uix
         KlkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qVT8S6li2syJt2/nbaWPBKrgHixkjbNBL2xOtiUcH3E=;
        b=qpEN3l6+2Ut0+zp35eYOxFbWJEwvx7K/EAFVG+vTreOVlm/9SXch8R40Tz+lYKyi7K
         yyvmzHjDRKDc4JCoQpKafga8HbalWkV7FnvkkcoebkMBzo//P1j99APLY6YwPcvymbXD
         /QmstXqb+q9UwM5RcXTrzKN6mStwy5QHe7DTrCjnW2L28hIO5Fs8kMI+XVaURL76qk5S
         yLS4kWu4RIQZQ7zSID9W+GkDlFUvyTUE1P0tRhu3MhAhpEnogqmwVVPZQYv9Kk7DFk9o
         8yceMaZidJUe9GTxCzJWcm5h8Niv9ClkVa8tYlopqaLrQKGrF+d/UTf56Qnb+o4BoSjP
         Lwlg==
X-Gm-Message-State: AOAM532QmN6hmhugJI2eZdk6WigdqGr2hhU6yqA0uMdBRv1s1abjgm1v
        MT6LTCCzPCBmh+cKMYa2DEGaudnFBR7guNN4Tc3hkkn24gWZMg==
X-Google-Smtp-Source: ABdhPJxlNnPky0cOE/XS9C2RX3Co2GFzX8FjzUe7pRzvU7f8KuOJUQOh5eBG/5fbzDUsYmJiyxjOnsS+auZfe1FDa4Q=
X-Received: by 2002:a4a:b307:0:b0:324:c7f2:386 with SMTP id
 m7-20020a4ab307000000b00324c7f20386mr8658440ooo.18.1653313196697; Mon, 23 May
 2022 06:39:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220504010242.1388192-1-vineethrp@google.com> <20220520160842.75d0ecbe@gandalf.local.home>
In-Reply-To: <20220520160842.75d0ecbe@gandalf.local.home>
From:   Vineeth Pillai <vineethrp@google.com>
Date:   Mon, 23 May 2022 09:39:45 -0400
Message-ID: <CA+HDTgQ_pvxA6jwXCE2tnj_YWQCcqOLR9FBKRmX68THXcZGkfQ@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: rework of the pid detection of vcpus
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Joel Fernandes <joel@joelfernandes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, May 20, 2022 at 4:08 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
>> +     be32 max_apicid;
>>       be32 page_size;
>>       u64 trace_id;
>>       char tsync_proto_name[TRACECMD_TSYNC_PNAME_LENGTH];
>
>Unfortunately, the above will break the protocol for released instances of
>trace-cmd that is already out there. One requirement I have is that if two
>instances of trace-cmd use to work (on host and guest) that if you upgrade
>one of them, what use to work still does.
>
>We need to figure out another way to handle this :-/
>
Ahh ok, understood..
I think we should also think about versioning the guest/host protocols
because this kind of situation may arise in future where we would need to
redesign or upgrade the protocol and trace-cmd should then be able to show
meaningful message to user to upgrade the binary. We might also be hitting
protocol bugs as well down the lane and versioning would become necessary.

>> -     for (i = 0; i < tmap.max_cpus; i++)
>> -             tmap.map[i] = -1;
>
>Note, we wrote this with -1, because we envisioned working with hypervisors
>that may not be Linux, and that PID = 0 may be legitimate.
>
Thanks for the clarification.

>We'll have to investigate a solution for this further.
Sure, I will have a look at this again and see if/how we can fix this without
touching existing protocol. I was thinking about adding the pid details to
debugfs and then reading it from there. Its not optimal as we would need a
supporting kernel, but it would be accurate if we have kernel support and we
need not rely on trace messages to get the pids.

Thanks,
Vineeth
