Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FF1196431
	for <linux-trace-devel@vger.kernel.org>; Thu,  6 Jun 2024 15:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717688353; cv=none; b=Lf0wEZN3Ob1V5qVGqLzmf6EqHhI++WjNdVIL2TXGnwm9vQ6Wcf/fQx0IjRi8fz4e71ToGGcqPi5sCtmbJ3/htPuw058mCpePChni7KyxG6Chmt6r0XMQH/sAXcHHJCElCv9d4qzLtPPTt7FxAqjmVuPBiqUArpAGnDquHz2vgVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717688353; c=relaxed/simple;
	bh=k5CY2NF9fSYWzIIP8tbpKKz11oAGtj12r0e9ZtIix68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bU7lPf/JOTL6U/kEODEEpAc21KiAuO/mbLUkrtOmAyyZgT4FtE9P6qv2sAvQfeBKHiSAIQDmeMfQ99M0VD2X0nAnW8Jl5lU1hx4V0rkWirJJw0m60Y+b/IRDeoNB/9/gicVd0FqgGuK+TEPBhiUMYkIxBUzC+7hVRtlXNesXRPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JTAzjMfu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JTAzjMfu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717688351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zbkjbZfzlbGT/XDsHf6clPJO8PId3qEXpzHdZWGjWXs=;
	b=JTAzjMfulm6pyFoG5znBSjMeeM896x3t8mBXCm0G9JYcjbekTxhoaq49d7aBCQHN5c6i6v
	QczxBQ4GJ1aQ2lu4V4gx7JmSnwk8Rc0HKLfuQgLEhQWwZQ0exzwvQ/HOdUtLwlLvtLZuDz
	06M7Iu4h9IuBSWymR5wMqZLsYRIxcUU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-1-l0xOJXApNP-HHC6JwXrueg-1; Thu,
 06 Jun 2024 11:39:09 -0400
X-MC-Unique: l0xOJXApNP-HHC6JwXrueg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A46829AA387;
	Thu,  6 Jun 2024 15:39:09 +0000 (UTC)
Received: from fedora (unknown [10.45.224.84])
	by smtp.corp.redhat.com (Postfix) with SMTP id E7FFBC15E6C;
	Thu,  6 Jun 2024 15:39:07 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Thu, 06 Jun 2024 17:39:07 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 12/15] libtracefs: prevent memory leak in tracefs_dynevent_get_all()
Date: Thu,  6 Jun 2024 17:38:26 +0200
Message-ID: <20240606153830.2666120-13-jmarchan@redhat.com>
In-Reply-To: <20240606153830.2666120-1-jmarchan@redhat.com>
References: <20240606153830.2666120-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

Free events in the error path of tracefs_dynevent_get_all().

Fixes a RESSOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 src/tracefs-dynevents.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/tracefs-dynevents.c b/src/tracefs-dynevents.c
index 7a3c45c..85c1fcd 100644
--- a/src/tracefs-dynevents.c
+++ b/src/tracefs-dynevents.c
@@ -589,6 +589,7 @@ tracefs_dynevent_get_all(unsigned int types, const char *system)
 	return all_events;
 
 error:
+	free(events);
 	if (all_events) {
 		for (i = 0; i < all; i++)
 			free(all_events[i]);
-- 
2.44.0

