Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E536E12BEA4
	for <linux-trace-devel@vger.kernel.org>; Thu,  9 May 2024 05:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715231613; cv=none; b=sb5/p/xWVgCmzMlamMbHPQpjdZCR/rbWHtJHOXIeLrkFXzhiA4hFaBYNLBZcPtlM1gcAu6Kn6rIEzSfwUKqzmHAWY1B5ZRWajsvXc8mIMCNtdDx+DDXOLcBexbY6OWYA2Jx9b/ICvV7K2D4d4nk0u/KglT/yJpx3c3F/byFrRME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715231613; c=relaxed/simple;
	bh=Xnc/V7rOpkBq0qBVerXCzEiC38lXXOtzK6nIFNZg+BY=;
	h=Date:Message-Id:Mime-Version:Subject:From:To:Cc:Content-Type; b=u7u4yXYNxX8O7nhyyPFHP7bbhddrTwQ4U9/N5ZGakY9jm42FbcFJUaHjXcl1CqIsau+tKsKL6OAqntOzDIGF5qVgbNyys6U1sU9ZUm0x+fkvEaGbOtdMzLL/LVcyX/HY3/D5qC+LyznyHze7eAvZtJyOrMDPUmX3MTXj62p0BRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XiJ9597d; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XiJ9597d"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-62079696c58so8816997b3.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 08 May 2024 22:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715231611; x=1715836411; darn=vger.kernel.org;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2YUMBiNhubBPozkVKJvzq+frE+Rw78B682uG5BiFquM=;
        b=XiJ9597dqyQQig41YvjzO1doM6sLkPjqjjPOfAfMwrFSlcBCTwUhU38DFVGpHmkqBL
         /iqzJ4wAueoazLUuGxWxcsWLXXUfT9cVlKtFS42RlFAmyqc+kxn6AJhC7YaBm3pRBmRr
         FsGb/n96AyE2utCG47Lel+k7HEI2Z5+irXYJPNbF/gS2Hp0lRgGkHZ1EY4c298Q/nZrh
         IPlKqHqsf+mWO2MMNdOvS1lwXhMj94Zs3ghfnSDDPcI1cby8mRxPP1LzuD2egN6uw9ZG
         I5AxRplGcm6r6B3FJsJa23namZSiv6djGmd7Dr4uhkySHD3CrH/KGKHpldFaNDS4Xvfp
         npmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715231611; x=1715836411;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2YUMBiNhubBPozkVKJvzq+frE+Rw78B682uG5BiFquM=;
        b=E5829MfqLwZ7ix71+AzJfSJs6qBj7cxc5fdz8JS9xRqhmh3E5TDZzlIYNZHEHZ3uns
         PE2ou12l77OU/1VAQDhmCupuYLXb6F3hSthVhVPQXHgL9VdFTCEOJjgJABy9pyqL00tf
         gAXjSB3lAdeoWmULJ/XSppo6gAKaYkWWL0DWr6rlJd3U9ELOBXhxcpOlWijK0E2xedFk
         YqcKqqVBQiX8VsNtFE47gAZ7BmHIsba+u0fI+CZ+lyVwSnEbE7zSdPYBa4HxEv/9tnNN
         hFFNDNE8L6B71dgw7eXN1IwW96/p8VrcF8MjZ1XVMdNVXSPErlQTfxuLyk2Y1D8Jx5z/
         Hwhw==
X-Gm-Message-State: AOJu0Ywh2OefsZZObXocUXqVllhrnSPvLJ3nK1K9ub+4Xnp/tuRDzkLn
	+GcpacuKfMXDvOXcnlJtYvvJiAS2xNoUBkodZYf5I14d0+lgRrVkQyKtYPS5PlxI2u6S1pheEbY
	XKZpD8/G4VgV2scSswnVuvKDcemkQj3FO71kKnEU9Z6J2nt2GVc2cKl9Hzudjj990vu5WOA0+yz
	VODB3uCfk+1p2AjiL968AIgi017ZLKAUMsespiYWx0/PNRl9jePACB
X-Google-Smtp-Source: AGHT+IGm3WZ21IeStnYv8TZdXhLwRalsqea+bzBRmu3UvvZ0Jj8ntMvN4WzwFbpws0jFkum8AXmuRi4TENuM
X-Received: from irogers.svl.corp.google.com ([2620:15c:2a3:200:3887:270c:55a5:15aa])
 (user=irogers job=sendgmr) by 2002:a05:6902:1109:b0:dcd:875:4c40 with SMTP id
 3f1490d57ef6-debb9e3dc10mr1438576276.10.1715231610828; Wed, 08 May 2024
 22:13:30 -0700 (PDT)
Date: Wed,  8 May 2024 22:13:17 -0700
Message-Id: <20240509051317.1913001-1-irogers@google.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Subject: [PATCH v1] libtraceevent: Avoid a simple asprintf case
From: Ian Rogers <irogers@google.com>
To: linux-trace-devel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Cc: Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"

Avoid an asprintf for the single character TEP_EVENT_NEWLINE and
TEP_EVENT_DELIM case.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 src/event-parse.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index b6ae67e..16fdb46 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -1232,9 +1232,11 @@ static enum tep_event_type __read_token(struct tep_handle *tep, char **tok)
 	switch (type) {
 	case TEP_EVENT_NEWLINE:
 	case TEP_EVENT_DELIM:
-		if (asprintf(tok, "%c", ch) < 0)
+		*tok = malloc(2);
+		if (!*tok)
 			return TEP_EVENT_ERROR;
-
+		(*tok)[0] = ch;
+		(*tok)[1] = '\0';
 		return type;
 
 	case TEP_EVENT_OP:
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

