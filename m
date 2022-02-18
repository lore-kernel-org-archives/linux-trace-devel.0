Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A9B3C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Feb 2022 18:49:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbiBRSt4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 18 Feb 2022 13:49:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbiBRStz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 18 Feb 2022 13:49:55 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E830634647
        for <linux-trace-devel@vger.kernel.org>; Fri, 18 Feb 2022 10:49:38 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id c23so3908499ioi.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 18 Feb 2022 10:49:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=PtAqm/y1idT0kABth5a3/8p0cxTf99GxWjfg/lmrncQ=;
        b=PGX/EHAKF/lsgHs2mR0M2iEWCJOLG5rWWHAULHIFiegcjSt6PJGxwZK7YF7R5js4XD
         AtFy8B672uqYvEjijsrz6X/wkvlu7T9vrrO8HbC1jIpw0+WygdkZFfQF1/xGSUPpsUiN
         K4m9xo3SaywUI8xCISbnuuatCd1pvcWBvYZxI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=PtAqm/y1idT0kABth5a3/8p0cxTf99GxWjfg/lmrncQ=;
        b=5+u/vdgCIteesRNIa2c2L8DQ6i7LutsolFeukVLkiewkK5YbzSmCgAWfibAxwT4+4I
         v5xsIFg1hD/qBujRBx/3Q2c4KAUpfN7lcbVs+C9Oo3eijjxWA1Jrql1z6WUP6r+KiYR2
         dEgHsPx5lOUKOBAUg0+8BQgsyTP2PdIgkyUJC2bz/XqbWijWeMuII8Rte9ySmsqP3bpi
         DtO3x/Jv+nY+x//gaB2QrRHBBHzONPuuL6/fGg8BN6v2RJzkykkWUgpwspFcOSAwKS73
         A/cZZGNfkZmZXEOSB8AOdriq6Yxpx8x9OILQ2QgFyRwqWz2dUbGAgyUYCv/CvsrRxRcC
         gRZQ==
X-Gm-Message-State: AOAM5315U3+xqvg0L+bUuMf1OBILXssquTCg+N30veiP/y7TQb0fB7Yj
        1cZF0d86YpBa2lGjXnSRvybkTxRs1G2GbViATuH5yfz8XHY7mw==
X-Google-Smtp-Source: ABdhPJwL0e7OLYthkz3TmX3BG6EIP8ugLc/xb+uGRCagb7PmWtAGIHpcBU1nRt1AbID2jspo7fDkGd4+dJTwI9OwVp8=
X-Received: by 2002:a05:6638:a8f:b0:313:f8d3:efe9 with SMTP id
 15-20020a0566380a8f00b00313f8d3efe9mr6125680jas.304.1645210178197; Fri, 18
 Feb 2022 10:49:38 -0800 (PST)
MIME-Version: 1.0
References: <CAEXW_YT5sCze=m-HubMjNLKmuUMqNQ_VbnT+7mmOULC-rJO8hA@mail.gmail.com>
In-Reply-To: <CAEXW_YT5sCze=m-HubMjNLKmuUMqNQ_VbnT+7mmOULC-rJO8hA@mail.gmail.com>
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Fri, 18 Feb 2022 13:49:27 -0500
Message-ID: <CAEXW_YQ=NJfiK9eUGxBb+FaoGAeK6gxHQh68gTLDzUOjAgbPnw@mail.gmail.com>
Subject: Re: Rotation of instance traces
To:     linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Feb 18, 2022 at 1:45 PM Joel Fernandes <joel@joelfernandes.org> wrote:
>
> Hello!
>
> I am seeing something weird with trace instances, that I don't see
> with regular non-instance traces.
>
> If I enable some sched events and set the buffer size to something
> tiny, like 1KB, I am expecting the buffer to rotate quickly as it
> overflows, but I don't see that:
>
>   watch "cat trace | head -n 1" and I see the following
>
> https://paste.googleplex.com/6259651512369152?raw

Oops wrong paste link, I mean I did:
watch "cat head -n 40 trace"

And I get the following paste:
https://www.toptal.com/developers/hastebin/raw/iqaqusiyik

Thanks,

Joel
