Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DECBBC4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Nov 2022 13:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbiKVN0R (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Nov 2022 08:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233771AbiKVN0B (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Nov 2022 08:26:01 -0500
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77933654CF;
        Tue, 22 Nov 2022 05:26:00 -0800 (PST)
Received: by mail-vs1-xe2d.google.com with SMTP id d185so14453532vsd.0;
        Tue, 22 Nov 2022 05:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pw2xlG6rMe5Ao0CyMu798tEaaSuiwwHXzHjU2e3DkrA=;
        b=CxlDYLzMczy1gxScW8IKkkPGcqdrxSBYtwf+PFA8bq+WRlFscim5a5teuBB+tB8cfZ
         znC1PsOpnGS3gyqcrVjDkg6uOvLc0e/Hsyx3GfOISyLflN658ATk4LCxvWxCh/J4QXhG
         AT67ozj/N6IFlc9+dru3Wt0bMzOS6pIcPUy0qgyfdqIaXDiEwVEQ3KJurW71WbKo1whP
         Y5fDNEX7u5gUQmDTlChRoudZzg/D9jWJjAxM+AYDEcPiWoY0R3fX2RqNKOz5T0uPGFAG
         3gZhtNpzXcsefrL6YyhWoBS5IW1xVcEVrrUAET9BkwcT3MQ+NRMRr8GNrd4QpW0acRwH
         oIow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pw2xlG6rMe5Ao0CyMu798tEaaSuiwwHXzHjU2e3DkrA=;
        b=4FDT1nldk1EeUlkOjYMLPHfux4OqSaB1XVg9PuxYXqdSeQUcxnHlFdPO16qYTDP2px
         MUKj7nek+HFr5z2zsw7FOi5Gx0YvoCve9i1H0wfcDF7BkOQlo/bkl6+vNHWJHf3p5/38
         rk+QYGbhTRgsmO3uQdBQ/O2apAk9AcSKug1lC3wiuy2jbaXwsW52s9SbfJQs6BKZBZNp
         csaMO5ALGNl4AjNkANS5RzSZSrWw0jORWz3GBLkpN2Wjpq+8ldg0U9KQnIPrelfsqfws
         hS6CXN+t+098e7hJysckjyRVqRRanjcce1jISyUTpXpfPgqZ8GkK2QV0EWQky+J0QX1l
         ocPQ==
X-Gm-Message-State: ANoB5pnbU9egeDMa/8P/+Y4+E5kZpVLXEZGLr9FrF/quftDH4TNj2ToP
        oYW62jZ3fu39elZn0rRbca0mU5/kDSNph7U4YKK2kltjCpk=
X-Google-Smtp-Source: AA0mqf7Nk6kpU0v7CV3Xc+KjDIsD8Z5ej27TSt0WFR+C6XxabdIGZOnRMc7MWCdMhi4z3XeZA2LFLTMn3esz9iht0UE=
X-Received: by 2002:a05:6102:3f45:b0:3aa:6996:c20a with SMTP id
 l5-20020a0561023f4500b003aa6996c20amr3024896vsv.47.1669123559268; Tue, 22 Nov
 2022 05:25:59 -0800 (PST)
MIME-Version: 1.0
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 22 Nov 2022 15:25:43 +0200
Message-ID: <CAPpZLN7EMZNFL4dFkCSxGVj8SLy=+qVfoOqqRdkNw2CdnfFHPQ@mail.gmail.com>
Subject: [ANNOUNCE] trace-cruncher 0.3.0 (beta)
To:     linux-trace-users@vger.kernel.org,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Notable changes in the new trace-cruncher release:
 - Introduced initial support for ftrace uprobes.
 - New flexible wait() API, useful to wait for various conditions during
the trace.
- Improvements that allow trace-cruncher to be used within a container
context.
 - Introduced github development workflow, additional to the current
mailing list approach. Both development workflows are supported,
patches can be sent to linux-trace-devel@vger.kernel.org mailing
list or as pull requests to github.com/vmware/trace-cruncher
- A lot of fixes, documentation and test updates.

See the changelog for a complete list.
https://github.com/vmware/trace-cruncher/releases/tag/tracecruncher-v0.3.0
-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
