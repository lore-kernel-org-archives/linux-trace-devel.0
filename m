Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1889F1974F3
	for <linux-trace-devel@vger.kernel.org>; Thu,  6 Jun 2024 15:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717688357; cv=none; b=UmLQrWBimadNXNOrzy+wVNrljezT5Yttva+1c7u9l5hKb7YGMNfKOgl70wZrpsU4jPQgXZzLQ3tDZaHlgAcCQa+kgzuESADI9vxpoAmYWWRI/uw/7CuP0kLzhb7Sl9CWXgf+CPbhE1euSLB2F5qWJL0N4+7tWDE6/YQkwRYxuN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717688357; c=relaxed/simple;
	bh=gntECSRBiIbB760dVGvzw5GbzWB7/9C/0YHOD7hdKYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JIAA3S1PHi44h1c/AYKIVEXjToJoY8MloxlUxLte9f7SzK9KUF5yZuEBwikOynMTNQAHLoskNPBGzKn6l8QWjwqJ3cMup7dAa8lY9ulsHigjzSrsH84BRQd/bq+NlQ+n8AI2MMg2qk5F4Itbhd4uHjIN+XRD4jR+W5FqQVDcO+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QXC+WWJf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QXC+WWJf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717688355;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mBhcsA3Ov3CAAQPCz4pGtUcTfYYi4vZNRs8juWNtZ5I=;
	b=QXC+WWJfZ5AqJ6K7/jqnR1pbkqOryfOxOcB2E+crfz1rAccaBlrE4ncNYOQp+L01ch9T57
	3uns9CwsTDorK1CY+ZED46P5M7bqiUsWPJNep75RygzV2H9P1ZXvzBIKWHDATZZwpYtgj7
	6iJxR/Em8+kxRZJCbwSB7JbHuNeV050=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-122-axKibFk9NVemIZ9TOl0QxA-1; Thu,
 06 Jun 2024 11:39:12 -0400
X-MC-Unique: axKibFk9NVemIZ9TOl0QxA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B8AD729AA387;
	Thu,  6 Jun 2024 15:39:11 +0000 (UTC)
Received: from fedora (unknown [10.45.224.84])
	by smtp.corp.redhat.com (Postfix) with SMTP id 3DCAE37E0;
	Thu,  6 Jun 2024 15:39:10 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Thu, 06 Jun 2024 17:39:09 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 13/15] libtracefs: close dir in the error path in tracefs_system_events()
Date: Thu,  6 Jun 2024 17:38:27 +0200
Message-ID: <20240606153830.2666120-14-jmarchan@redhat.com>
In-Reply-To: <20240606153830.2666120-1-jmarchan@redhat.com>
References: <20240606153830.2666120-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

In tracefs_system_events(), we don't close dir if add_list_string()
fails. At this point, just breaking out of the loop fixes that.

Fixes a RESSOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 src/tracefs-events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 88325e1..1fa3f2f 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -922,7 +922,7 @@ char **tracefs_system_events(const char *tracing_dir, const char *system)
 		free(event);
 
 		if (add_list_string(&events, name) < 0)
-			goto out_free;
+			break;
 	}
 
 	closedir(dir);
-- 
2.44.0

