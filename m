Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28864C433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Apr 2021 03:09:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDDBC61415
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Apr 2021 03:09:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234023AbhDUDKM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 20 Apr 2021 23:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233982AbhDUDKL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 20 Apr 2021 23:10:11 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B168C06174A
        for <linux-trace-devel@vger.kernel.org>; Tue, 20 Apr 2021 20:09:39 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id h4so30706497wrt.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 20 Apr 2021 20:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=WgwHS/vAAMsHzUtimB5FOXo/9VMLa79DoPGZF2/bXmw=;
        b=Rd6/SXSdj4MfkJKAK4yG7xFCVAxaIFM/+9F422PXKBcscn3i95ECaZFoIaTnr78deH
         mRYbBr0JDA24ywlVTPlBicU0P4hVXmNQb5RZCS6q4JwibuTrUENGAtRGrXKevKKIh51x
         hAup045HBaGZICX0bfOiiIdVGqj1M2p2TG4Mk4bA6IOzVvkTkB4S1I3ZTSoyBetxusTe
         hzf/p8DW0bdriOT0fcbK0W2ijv7OeDa2xygulfn5zzQ86eGV8JdsHdp2WrA0fVkAGxlA
         OHcIsOt05+mfZ0Mn7SCuZ+yNfZQOqgN8vlhRntiizLNoP29F0yz4kNkhFYVZeSjMjdyL
         O1MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=WgwHS/vAAMsHzUtimB5FOXo/9VMLa79DoPGZF2/bXmw=;
        b=ptr6auhiZi8XQd1p8nx6rDzMMk4nsEFFBGyUJY2rrVVefJ4OLw+lm6rASRIaMYMtdf
         yr9UbbpBu5TLmIArXd5E8d3vauHYmpGJkGM3LI6TRK4/yJjk685K9J5DVmLvGErEhtu2
         AC2anG55w6+uXe0NO92OAT8mqQ4Raky6P+uc7d2YG3H28VQ94QKhID2oNXzAknrIOstu
         Ihm/757ZKezqC3UcDkCqi1B817ibILnLI0gHdFAgTcam6w8vrXwyAebQRDwl0Fu4hJlQ
         fQVKdYFZvt7fAEzufNMGTub3z08YmLWEyVrE54RE9mw20RajpNAyPZq7LH+/82XD9q6c
         h4QA==
X-Gm-Message-State: AOAM530axEhOVcAZ9JFudQ5ZWSo/zLfwkF9fVXo7OM3l030CRvhIfkSk
        BCle4+eMdInhE8lZwMorAhQqTlkCPngju2QMAJfeiGdXs7xVlA==
X-Google-Smtp-Source: ABdhPJwSugL30CncE6nhZKmzAhui3oWa9anUOYDLu/mCz+TgMFLLRpAFVZl3536qc4ZtdmWp57DeSj+QxlMpPY5QupM=
X-Received: by 2002:a5d:524e:: with SMTP id k14mr23795475wrc.282.1618974577586;
 Tue, 20 Apr 2021 20:09:37 -0700 (PDT)
MIME-Version: 1.0
From:   Ian Rogers <irogers@google.com>
Date:   Tue, 20 Apr 2021 20:09:25 -0700
Message-ID: <CAP-5=fWSDxOxBsoK8koaNbJwTVgjJwzoVe1jYuoX-Vhvteqcqg@mail.gmail.com>
Subject: libtraceevent and copy in linux/tools
To:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi,

libtracefs [1] has a dependency on tep_vwarning which is declared in
libtraceevent [2]. The libtraceevent in linux/tools lacks this [3] and
so trace-cmd, that requires libtracefs, can only be built with the
separate libtraceevent. I'm trying to avoid having two libtraceevent.
Should the copy in linux/tools be updated or should I not be using
that any more?

Thanks!
Ian

[1] https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/tree/src/tracefs-utils.c#n33
[2] https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/tree/src/parse-utils.c#n14
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/lib/traceevent/parse-utils.c#n14
