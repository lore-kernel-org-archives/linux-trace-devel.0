Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38BA4C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 24 May 2022 15:35:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbiEXPfx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 24 May 2022 11:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231731AbiEXPfx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 24 May 2022 11:35:53 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508E4580E1
        for <linux-trace-devel@vger.kernel.org>; Tue, 24 May 2022 08:35:52 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-f233f06563so11076002fac.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 24 May 2022 08:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X7cNaM55JAWOKA1/w809k8ceGl1bJ3qVly9hGwnlUVE=;
        b=cUaaNC9E80HPon0FTF7XpXKTg1DodCuFOLJzVa6sBz2y9jhzjU32ZLbSTe/QkcH7g1
         RI5/GZC5sX45WKX16iKxxFAmmv3p88qHyaqaJ3wgS9h9KcJtJecyiaiImvbfXC8RosHk
         njJt18XdeJUfF/v0N3eDlCL3B18EsdZN2+GzHvs8AHUS4pk7WmjjeC88kXlNeFrXzqCu
         /VHrJNgdyc43SsKnEdm3FwiGQo4158CGmtsgD2Rvf+vZzFY+kmX1wbqHQmo4ulNLHffv
         t6pjCMFFpOEmdlvCAd7R6WfIjc/iQihYgK4pFGIYQu31QvW2KoCJpOv5nvO/71i+udTN
         lciw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X7cNaM55JAWOKA1/w809k8ceGl1bJ3qVly9hGwnlUVE=;
        b=c32qoslNGv7UafUe8oNMJMEcIru4/ErtDbAw8BKgPYZ9e6W+4mYiWxodxmq+7mGrNQ
         TnNU1DRVUchLRLZcqgYBeZixvJDq0E5pQGVfq9ngv/ZMtzp6s2rA6V21UCGGnP8MM4IQ
         ACl6v28QIk7ibFxGWghjVAimYSTLcSdGW0IPm0Fo8vfnoF+WjQzlwx+b9Rw96+PtrYYk
         YYZEASRcMdYo9zbA2xvV/qO+xY5p0hIBhJGPhL8BpibFReBJgw0FWDw0PJcTWWqemdDv
         ieoK5aRioXeDonrNit8BtUChvaXhLsqGDV/LNk4qcneB0j1tQSKoadOYOSslq8qYTQMR
         4X8g==
X-Gm-Message-State: AOAM531B/1aWbPaAMlsZqDahuA+w5vo0tO1XY0Kfc7RX9spZigjHsbpE
        IfhY0UlsybHBwwLsPRqPujMMCzEO9AXRv7nXDTfhOsQdQ+N/vQ==
X-Google-Smtp-Source: ABdhPJwj3xkcjDqDwCCfKbYPmb8bh15f8XJV6kB3U8NPiiK4B3wMqtWDNtikFBdvSsbHb+yyPwQMtub+4cwt+5uB+U8=
X-Received: by 2002:a05:6870:461b:b0:e9:a015:36a6 with SMTP id
 z27-20020a056870461b00b000e9a01536a6mr2646679oao.185.1653406551415; Tue, 24
 May 2022 08:35:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220504010242.1388192-1-vineethrp@google.com>
 <20220520160842.75d0ecbe@gandalf.local.home> <CA+HDTgQ_pvxA6jwXCE2tnj_YWQCcqOLR9FBKRmX68THXcZGkfQ@mail.gmail.com>
 <20220523094700.26eb2a05@gandalf.local.home>
In-Reply-To: <20220523094700.26eb2a05@gandalf.local.home>
From:   Vineeth Pillai <vineethrp@google.com>
Date:   Tue, 24 May 2022 11:35:40 -0400
Message-ID: <CA+HDTgSV3sHD_59dN=NLa4hY_bD3d4ePOwnwJgCM46SXyCEKJQ@mail.gmail.com>
Subject: Re: [PATCH] trace-cmd: rework of the pid detection of vcpus
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Joel Fernandes <joel@joelfernandes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, May 23, 2022 at 9:47 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > I think we should also think about versioning the guest/host protocols
>
> We actually have that. We are currently at version 3. If this becomes too
> much of an issue, we can always move to v4. But to do that would require a
> lot more thinking, as I like to support all versions, and I don't want to
> have a lot of them. Thus, if we need to update to v4. It would likely be a
> entirely new protocol to fix and extend the issues of v3.
>
Thanks for the details.. Yeah, doesn't make sense to have a version
change for this.

> > Sure, I will have a look at this again and see if/how we can fix this without
> > touching existing protocol. I was thinking about adding the pid details to
> > debugfs and then reading it from there. Its not optimal as we would need a
> > supporting kernel, but it would be accurate if we have kernel support and we
> > need not rely on trace messages to get the pids.
>
> That would be useful too, in more than just trace-cmd I believe.
>
Posted a patch upstream for exposing pid in debugfs:
https://www.spinics.net/lists/kvm/msg278146.html

I shall work on trace-cmd changes as well once the above patch
is finalized..

Thanks,
Vineeth
