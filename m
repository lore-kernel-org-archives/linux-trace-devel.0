Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 054C5C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 May 2022 16:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238979AbiEFQV7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 6 May 2022 12:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350965AbiEFQV6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 6 May 2022 12:21:58 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B71BBC85
        for <linux-trace-devel@vger.kernel.org>; Fri,  6 May 2022 09:18:15 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id g23so9255801edy.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 06 May 2022 09:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:date:content-transfer-encoding
         :user-agent:mime-version;
        bh=hRQaE33a5bBbH2bFeU2Uoe3R6o4WkQWoAhBBpc1uhwU=;
        b=hMghvRCXgcjD1VCFdlbeKsYEfLIxpwRf0IH7lJyqTBPxPgdVf/YRc38mpfGPCGmvS8
         O2qL+vDWmojXkIKdxQeq6ptabZJ+d68k7qz/knDItXXakNHWgWCTq4FFoptism3Qlz7z
         8f5hkgoitFx2ZlpgceFfBH/mM6O0a8EVAnnh13M5nHqjxoqKcL6Bs5ST7y82cjmqc5i/
         hUTfB1iUuAtCM/MR78SOP5jau1xGImZLwFHZPJRARu8YL/QkLMPrR6J9cVRB2+wHJne6
         DYAumlWjWbo2893Zc9IC0gg+4neCMjSV++EmOsmt994vIHyd8QQZiCPocmfpBEOQbOgO
         PP0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date
         :content-transfer-encoding:user-agent:mime-version;
        bh=hRQaE33a5bBbH2bFeU2Uoe3R6o4WkQWoAhBBpc1uhwU=;
        b=AmCnD0XtgeiG8Jtq+RyzryYLNX3FJDWfhQlD62CzNFMzKuzTxZjy/EOhV/z5DH4HN+
         hAS4lvqfaRF/VxwSwBOjOXyrfwBrmGp4GiUWpXd+YDThhg8J2UeKZ8omq/tnjnLW80WS
         lDkprzdlMvBYsSBbkwRZVmjOP5V+aU2O7a7Ay6bJGLuU1KlGSR8DTFonlb8o1avdnowM
         A7qhx41jQftG9WViHZkaH26F6oqeROSdM58Obwia8RX2Pvts+ppKFnkjv6tzZsoLJ0d5
         RSocENcxPU25lALYdIo4XlVhQN9U4lRVC+up7XHdRndNEHfep8MSo2hw1NkLvc+XkDJ9
         tv4w==
X-Gm-Message-State: AOAM531LK5pCCMiHW+NAkOu26ZMF2XBD/4+EUz5MsqBUyk86plEnADKl
        33uKVM8he697Wn1eHJYNnbz+z6/z1rw=
X-Google-Smtp-Source: ABdhPJywJ7qzZMGaXkPcuz7ilNKwXK98z6xkO5QS5QwCbGbAr2eAl9hXPRT+7G65g4c4sqqoZSOcGA==
X-Received: by 2002:a50:a454:0:b0:425:e94b:2f1a with SMTP id v20-20020a50a454000000b00425e94b2f1amr4237259edb.330.1651853893155;
        Fri, 06 May 2022 09:18:13 -0700 (PDT)
Received: from [192.168.3.2] (p5dd1ed70.dip0.t-ipconnect.de. [93.209.237.112])
        by smtp.googlemail.com with ESMTPSA id w16-20020a170907271000b006f3ef214e42sm2041424ejk.168.2022.05.06.09.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 09:18:12 -0700 (PDT)
Message-ID: <93fd065420c6a04141b5e8ba9c89dae1e7c9b6a0.camel@gmail.com>
Subject: how to register an event handler for the instance
From:   christopher lee <christopher.lee.eu@gmail.com>
To:     linux-trace-devel@vger.kernel.org, rostedt@goodmis.org,
        tz.stoyanov@gmail.com
Date:   Fri, 06 May 2022 18:18:11 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.0-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi all,

I use libtraceevent in my trace tool to parse the event log. Now I
allocated an instance, but no idea how to use
tep_register_event_handler() to register a handler for the instance. Is
it possilbe to register handler for the event in the instance?

https://trace-cmd.org/Documentation/libtraceevent/libtraceevent-reg_event_h=
andler.html

thanks for any information.

Best regards,
Chrit
