Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831821974EB
	for <linux-trace-devel@vger.kernel.org>; Thu,  6 Jun 2024 15:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717688359; cv=none; b=QOztcF5sLhSZLGOJ04H4KeWR6AYPIJW4Hoqb3pZ3VP9iwtT4pxNx40A27Urb+gI52lQ+2ptRPIswNKxZoXwAdvB6iK3QKKeMHTVJiMkEE3tqIAFeu5uFgWidgUKvt3JUYB6+SI6UgwpW638MbnD8JPj/dZj8opgjVoW5j0u7pFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717688359; c=relaxed/simple;
	bh=XnTtbowSY0Il+/Zt4mRvEVEN8hgiBMuwZh/vp3+kspo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5Aa9EYMQTwFk2+uYlAuB3mRzOdFCTdIIHtKT5R8XUDHkUSV7/+jTE+qpaE8TXyEPQlThjIjuQUo44Gv9pim3wcct50EqU7TQdG5FuV9ECql4SCZH6SfT5IbBpgM1/ZfkllMJormAM4pJjqZ4kMg6GEsx1gmkRA5ojlDWJEyK70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lzsexon1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lzsexon1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717688357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wMXoK4xT6xU5YFiykxdbcTn+yoGIHWsG2EbjWfo+0n0=;
	b=Lzsexon15DkeUR1ShAfPBmHfNcm78tI6J4iDYN+mWEsHSecScyv9ymIoq9j4x/MDo2LA3T
	iMApYCxw8MVIBpVQu8tlGAt8PE3+qEKRlDwHH6kSwYTBATMlgv8Xkz31xEiXUtqW4kQ5bz
	KtyxS/zt+ptGvwyOJKQcaYTN2pgqNpM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-363-kHGMfV3lOn-W-EHzI5zzcA-1; Thu, 06 Jun 2024 11:39:14 -0400
X-MC-Unique: kHGMfV3lOn-W-EHzI5zzcA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EAEA418539F7;
	Thu,  6 Jun 2024 15:39:13 +0000 (UTC)
Received: from fedora (unknown [10.45.224.84])
	by smtp.corp.redhat.com (Postfix) with SMTP id 744A123D5B;
	Thu,  6 Jun 2024 15:39:12 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Thu, 06 Jun 2024 17:39:11 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 14/15] libtracefs: close dir in the error path in tracefs_event_systems()
Date: Thu,  6 Jun 2024 17:38:28 +0200
Message-ID: <20240606153830.2666120-15-jmarchan@redhat.com>
In-Reply-To: <20240606153830.2666120-1-jmarchan@redhat.com>
References: <20240606153830.2666120-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

In tracefs_event_systems, we don't close dir if add_list_string()
fails. At this point, just breaking out of the loop fixes that.

Fixes a RESSOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 src/tracefs-events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 1fa3f2f..83069aa 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -858,7 +858,7 @@ char **tracefs_event_systems(const char *tracing_dir)
 		free(sys);
 		if (ret >= 0) {
 			if (add_list_string(&systems, name) < 0)
-				goto out_free;
+				break;
 		}
 	}
 
-- 
2.44.0

