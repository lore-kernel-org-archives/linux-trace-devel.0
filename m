Return-Path: <SRS0=scwk=TD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B5F6C43219
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 08:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1787A205F4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 08:26:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kUnT+XWo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbfECIZ7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 May 2019 04:25:59 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:50807 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbfECIZ6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 May 2019 04:25:58 -0400
Received: by mail-it1-f195.google.com with SMTP id q14so7864795itk.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 May 2019 01:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lQEcgOqb/HFfyFWZBZgJ9YsXCTb2RoQyDAMslF7xpTg=;
        b=kUnT+XWoXiXFDrIom+oRx4Osv3jcdpquEEMv0l+Fsft5/H81qTvzz0XlgO5O0jomfH
         1s2EYLMOdmCpttV5IHstn725FFTJS6jUUjelmzFJrBAQ7nxQHdxsRpB4U0Fi0yjsURMr
         UjidVfeG22KRnEbWBp0UAQEHWIZ9nLBx3vRtl1vN6Ji6Rm+vj0VvtFOjzvwxZnfHRRRA
         InEImbSsX+J3V5KHQjEKhDZeBd06SsP0w3qghW2FLRV7FZ/e9uadLRcwE3R0ZYz1+AzJ
         XZP9DjWC68+DqTfBXjjZ5k09I50Cer1oTY82JPJ1F/bemfeRqXfcWClqw2ZvyQWHBHRB
         zddg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lQEcgOqb/HFfyFWZBZgJ9YsXCTb2RoQyDAMslF7xpTg=;
        b=sPcG5qQDW0RDvMJJkc5hKM8D/AawaJ+ZbVFoYvIBpVvm2HkS2EadShDBoCyRCnHZcs
         AtX3Mv44M6T/5dHoNDhjxUGk8I6VUFkWOEWenfCIBvi37MhKpkBW3JhnskeucY3irWfW
         8NhAK0080HjPiwq0qhy9QDvxmLeK0GwtptvUK+nU+k96DNqEmhxt0KkKeHrl4QXM8FGN
         t3Ry+nUCbOwWRn5W01UBxeU9OR7GLBW5Xp1KI8VKIhJrm9mjXxkoBHiVT7Qie4jdODHp
         fptRP05aaxpPL2ogP5LWPvKPLrWWZsuvMH18oKtUWbw5v+d95vnGclapwd1urk9sY7D2
         H6ag==
X-Gm-Message-State: APjAAAWiikPXSl/Vm0E5tQ7KkTJSllnyxYAC0VxYhJXxtHrYTZsR3yH7
        fpIctFfR6nd3nKBiW1OLZVsNr+B5+GOrYrOE6w==
X-Google-Smtp-Source: APXvYqzDYKNeNSe8LGogR1q6dQUO5rndzagD/q+UzG3WioM6rfVqPd8fQWtMb/TUC2t9ETm9gST18A7LS6Cs87kJB1A=
X-Received: by 2002:a24:b713:: with SMTP id h19mr5830957itf.73.1556871957548;
 Fri, 03 May 2019 01:25:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190502124536.32463-1-ykaradzhov@vmware.com>
In-Reply-To: <20190502124536.32463-1-ykaradzhov@vmware.com>
From:   Slavomir Kaslev <slavomir.kaslev@gmail.com>
Date:   Fri, 3 May 2019 11:25:45 +0300
Message-ID: <CAE0o1NsNek55HvAfiuOT2zn+B_PxAUuBbhr2Vx=EerWv_Heucg@mail.gmail.com>
Subject: Re: [PATCH 1/2] kernel-shark: Enforce update of the OpenGL widget
 when loading new session
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, May 2, 2019 at 3:46 PM Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
>
> This is needed in the case when the session was saved at different screen
> resolution.
>
> Reported-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark/src/KsGLWidget.hpp   | 2 ++
>  kernel-shark/src/KsMainWindow.cpp | 3 +--
>  kernel-shark/src/KsTraceGraph.cpp | 2 ++
>  3 files changed, 5 insertions(+), 2 deletions(-)

Both patches look good to me

Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>

Cheers,

-- Slavi
