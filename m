Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B2E8C4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon,  7 Feb 2022 16:55:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235998AbiBGQy6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 7 Feb 2022 11:54:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357080AbiBGQjQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 7 Feb 2022 11:39:16 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6FDC0401D1
        for <linux-trace-devel@vger.kernel.org>; Mon,  7 Feb 2022 08:39:14 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id w14so31359597edd.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 07 Feb 2022 08:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IB+d1Y5BRgLdCqTRs25S/swtJs2CbCN0kOoAxnHvQA8=;
        b=fI9Xk0GLwfgMyDCzQmDqjJpv/RsFbFz9KFZgsEC6l6jXG54rVluZyO+1dErub652Gj
         zasqAw7ZmUUf2v9qy3B5g2ymUFHVKeewXg50Av9ZjGby0OJMlbaXp/5pRDWhME7o29Np
         Ry0OHmeOvU5oi57dDqRyaXzuhi2wfqa4up+uK6wXZ8F1qOoRIl/XmcBPAKE2VPOSwZxz
         0R/T+yMlIVyhl8rgtZfq4fH7nAD0/ul8vpXcva/RGPRfQ6vMCi5/VuEIySjHJx4oIxVD
         QkwrwqYpJnuymPUgSV5bJntqanCX13JuhVh+RhV2xVWAZhyaGWHfUuWG9ArGPkPEwP32
         qhdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IB+d1Y5BRgLdCqTRs25S/swtJs2CbCN0kOoAxnHvQA8=;
        b=X0TJOwK83J0fI5dSKxwhSaqQLrXyzjgK96yCuo0CBdkrzs7kpUlBZJIVIz0BVyVSkv
         Uw2RcW9KYdaPt9gss17k/VWYiv4WFEedJOtJKVarW6+nnAwd4yszXu+/O8wSmC30vJAT
         RlW9IIf1/U5gwuY2tkyj0EqfWj1sEl7ASa3Kn7ABed422EGPqStOi9tWhkreEsz6+pjU
         +pC/3f8OPLCjZMIoxj6ZdYB0k+rWUG3Porx72ohEkJlqbTPdXG9kkitn4F0ho0xRUfTY
         DYc9XqBZFV4Pzq1KXcqbTK10GyVDZ7x7lEtrTOrqbvmVivRlg5kNPKgB6KVSj/wt2fiE
         jKKQ==
X-Gm-Message-State: AOAM5321ihHDlE/Kv+VhHEntgq5SDWvgD275I3vTjUsgoUlgpctESxxJ
        /H/s6WmtFxIgWxz/vU9KCY+c3wSosoc=
X-Google-Smtp-Source: ABdhPJz9eCGsABoqJyUFspi4QKjb9JXwApc9H9RaLZBt77wSrFaLKLVdwXnE5aoWXbJ9fEy/zXI18A==
X-Received: by 2002:a05:6402:1757:: with SMTP id v23mr308836edx.105.1644251952777;
        Mon, 07 Feb 2022 08:39:12 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id b7sm5415814edv.58.2022.02.07.08.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 08:39:12 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/4] trace-cruncher: Fix misleading comment in start_tracing.py
Date:   Mon,  7 Feb 2022 18:38:58 +0200
Message-Id: <20220207163900.178524-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220207163900.178524-1-y.karadz@gmail.com>
References: <20220207163900.178524-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new comment in the code describes correctly the example usage of
the 'enable_events' API.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 examples/start_tracing.py | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/examples/start_tracing.py b/examples/start_tracing.py
index aaeb0cf..367c626 100755
--- a/examples/start_tracing.py
+++ b/examples/start_tracing.py
@@ -11,7 +11,8 @@ import tracecruncher.ftracepy as ft
 # Create new Ftrace instance to work in.
 inst = ft.create_instance()
 
-# Enable all static events from systems "sched" and "irq".
+# Enable several static events, including "sched_switch" and "sched_waking"
+# from systems "sched" and all events from system "irq".
 ft.enable_events(instance=inst,
                  events={'sched': ['sched_switch', 'sched_waking'],
                          'irq':   ['all']})
-- 
2.32.0

