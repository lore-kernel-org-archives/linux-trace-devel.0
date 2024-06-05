Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407E1195801
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594954; cv=none; b=gUawPOERsucwslwlcWcRVzTY0HtKQTVWaMm0KqMWpsKogyd+5fn/KOJUP/SkxebUP07UhOzP7IxQEqSZoubxNS/s4Bw4EaOXEgQ+0Y+jWxBijutV4u7N+v6CMIu6X0E8/CoZL7uYzbkzkrRNBXLk/4xMBl4SIsVrgifH5zHGSmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594954; c=relaxed/simple;
	bh=NEaW4Mmb8TfoGv7lr2GJugQzfYqsHKFAhDnXEX6woPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUfEFu+a0VhUNKD+XNeLeOiUgfGXiVhcl7HYR9I4jduBwmrqhVU8CklJwpP6QYW+aHUcSNp4uzkFHwiHpPcqBTvolBn7GOuugpZRCZQ3r3WmskRqs/WpdRbkmxH/iiNpfjNqAObAwN27hyeWjh0kIKw9933wuBIzhiu9FBZS78A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c6aMWDq3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c6aMWDq3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594952;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EGjtt+ZInajUUp3yUqx/LLQEIhk6bbhaR/CRPy8T/eI=;
	b=c6aMWDq3AGv+8WTFEoWiAsvknQ5UpVIgb40ptO/sCXaEEthGe8NxZ5oiuE99yj1m1dnvrZ
	uGpHaiQfeVuvaBAWF+/vzx3/ohn140t0Y71E14vHtUypw9etLG75GedJORNy+TF9R6CPST
	UVR5HtUXh1RdT1CkqorTYKhcQnMCv9g=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-397-h1WGum5OPBiOr6xzl4oXIg-1; Wed,
 05 Jun 2024 09:42:31 -0400
X-MC-Unique: h1WGum5OPBiOr6xzl4oXIg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7F4F3806700;
	Wed,  5 Jun 2024 13:42:30 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by smtp.corp.redhat.com (Postfix) with SMTP id E2EC740D1B68;
	Wed,  5 Jun 2024 13:42:28 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:42:28 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 25/38] trace-cmd lib: prevent memory leak in glob_events()
Date: Wed,  5 Jun 2024 15:40:40 +0200
Message-ID: <20240605134054.2626953-26-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

Free event_path if malloc() doesn't succeed.

Fixes a RESOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 lib/trace-cmd/trace-output.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index c270d03f..7be175af 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -868,8 +868,10 @@ static void glob_events(struct tracecmd_output *handle,
 
 	path = malloc(events_len + strlen(str) +
 		      strlen("/format") + 2);
-	if (!path)
+	if (!path) {
+		put_tracing_file(events_path);
 		return;
+	}
 	path[0] = '\0';
 	strcat(path, events_path);
 	strcat(path, "/");
-- 
2.44.0

