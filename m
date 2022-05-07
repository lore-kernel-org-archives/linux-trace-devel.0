Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A7F4C433F5
	for <linux-trace-devel@archiver.kernel.org>; Sat,  7 May 2022 05:03:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445533AbiEGFHQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 7 May 2022 01:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445550AbiEGFGm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 7 May 2022 01:06:42 -0400
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767A86832A
        for <linux-trace-devel@vger.kernel.org>; Fri,  6 May 2022 22:02:57 -0700 (PDT)
Received: by mail-ua1-x932.google.com with SMTP id z15so3477331uad.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 06 May 2022 22:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IeADNa4GW7SOZqddAn3G0GpYHpwpLqKYz6r/UcvWcgo=;
        b=dQ3up8H/Ch9Hw0yA2VJlBK2qF5tIbXeV4GWtW9fSTRk+FUcUN1b6BcBy0lyBa2DksV
         GVKfBN1Wb8Bv5KnzXJ+ahWvS7QZEzDnTtgAvoJC1z+CAn8z+YVeNam6zu0bJ6SqC9cQn
         HCBgKjbRkvjOzhPhZOThcT8eQViuKxYHbd4dg5bc/tBdA85ncrXQsnETGRrKlSGvv2zP
         fXGiyHdjziZo6f4EK/YM3KfAUl3WrXfq5zYkSdTRATOamferD3phjPLCgW2zrzI0r+Zp
         01V2VcKx+GbC5+YJQN6ZLsfidbO9S+1nFx19d5EcN/0vgXlP/jMIX/RibUHrzP5gxtSJ
         oEqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IeADNa4GW7SOZqddAn3G0GpYHpwpLqKYz6r/UcvWcgo=;
        b=hg0i0xMtTG1Fv2byDq/GXuNYay5AV4K6nbJm/bqzOab7kEfM0O/QCwI7TYl5efM01k
         TTIfIh0TE8DakDvkPA6jTaTlSkuaIg64QYW5yDBVExSCpyiKyIO7N3eGSZ2iEndLBm9o
         4QT1x6AEzWiIUvnLgfJwOe1ZsUZ9ulUdg5/vDfQyd4AP+Fuc0vFhZcVwcmg+zVs3LP+u
         OVWe/HjITRvYI3zwPTHzqWgpTme/W48r+dEiiMk8yQ7xuFH2yujKvalcqZdyRRyMNgdb
         yitavZAbGxZvevi3LkoQ6fsosK6Ohp9vA9BD9bRlg1r7YNKFqAztC28Fd+c6GLT5u0P6
         8d1g==
X-Gm-Message-State: AOAM530MLUNo6qRdufgJC43lMATbsIzx407qgKbkiKpDDJ4GbaDADSIq
        6uS1Jga6igTSyoulSbAMtq7GH6zLCs+b2LJ1JB4=
X-Google-Smtp-Source: ABdhPJwACy/fAgBiRV4fn5vObeDpwnJ9Mz4weLI0IxyIDlmte6rq7ZolZ9nKfq9vb3qWx4szPQnr3BR10j7oCQkGzu0=
X-Received: by 2002:ab0:4461:0:b0:35d:36b6:3867 with SMTP id
 m88-20020ab04461000000b0035d36b63867mr2145523uam.37.1651899775637; Fri, 06
 May 2022 22:02:55 -0700 (PDT)
MIME-Version: 1.0
References: <93fd065420c6a04141b5e8ba9c89dae1e7c9b6a0.camel@gmail.com>
In-Reply-To: <93fd065420c6a04141b5e8ba9c89dae1e7c9b6a0.camel@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Sat, 7 May 2022 08:02:39 +0300
Message-ID: <CAPpZLN4A8tes3tnzDqLFBT7S2SvBixFwDW7GkYbSPeA+3e1yCQ@mail.gmail.com>
Subject: Re: how to register an event handler for the instance
To:     christopher lee <christopher.lee.eu@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, May 6, 2022 at 7:18 PM christopher lee
<christopher.lee.eu@gmail.com> wrote:
>
> Hi all,
>
> I use libtraceevent in my trace tool to parse the event log. Now I
> allocated an instance, but no idea how to use
> tep_register_event_handler() to register a handler for the instance. Is
> it possilbe to register handler for the event in the instance?
>

Hi Chrit,
All trace events are the same across all trace instances, thus the
handler registered with tep_register_event_handler() handles events
from all instances with a given id. That's why there are no "instance"
oriented APIs in that library. I would suggest looking at the tracefs
library, which is instance aware. It can be used to allocate trace
instances and read events from a given instance.

https://trace-cmd.org/Documentation/libtracefs/

> https://trace-cmd.org/Documentation/libtraceevent/libtraceevent-reg_event_handler.html
>
> thanks for any information.
>
> Best regards,
> Chrit



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
