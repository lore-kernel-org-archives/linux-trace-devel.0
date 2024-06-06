Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C30B1974EB
	for <linux-trace-devel@vger.kernel.org>; Thu,  6 Jun 2024 15:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717688357; cv=none; b=kL+oMMP5azRCKW2ySceJY/PMNRjkQKFmc7OYUZOMrQxeviAQ/xdaTZKJKCAuJrZpr3WalJHrJLOCK2te6C8lDd26g88w2ds23rX8dVIr9S7CKNtx5ljkyrhyUd8J7R2faLarRk9XCVUYWGjSIgHrSDN2E3+Ai6hySNIoJEzO2cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717688357; c=relaxed/simple;
	bh=ixoFcq5Za3Kis52ofTp5WWflVDqpQo/p/OwVBlzwAGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8RwF5Za/u4HxrqurdtOtzQ2JGcIKoEw/Cszq9f1WuIrPfcDHOxuD+njrpBw9ky458oLX+/XKHvAMsnj5ZT48SVwnWFUt7X2W4WWVK9onL66ZrBPT63bXQJ0de7C0FzgfHBB+mKx1XnZa/IDLc66nCReqdYp+Og36JF2a04pnF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rkgqyr4P; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rkgqyr4P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717688355;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tb2t9eT+nSFKssGnBMHtIgoxY8BqFU3dYVJ5aFVCeJE=;
	b=Rkgqyr4PSEu1cM4cdIQC0KH2MEiMFg9iJ9ZEHZVXrbeWy92JU53OmwuOGmL+lbcC4OmNwO
	klEUko7B8i85j+lvSJvKhHXN86kXrfCFtNMq5xfaf3FIqJdxVm6xk1p4CPMT6oN9uSTohW
	2kYemNWq8HU7gQ0FzPEC+7ZJkh4EtS0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-257-QAWA5OhaNt2jxNOeMa67iQ-1; Thu,
 06 Jun 2024 11:39:13 -0400
X-MC-Unique: QAWA5OhaNt2jxNOeMa67iQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E1AB518BF039;
	Thu,  6 Jun 2024 15:39:12 +0000 (UTC)
Received: from fedora (unknown [10.45.224.84])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 672B7197701E;
	Thu,  6 Jun 2024 15:39:02 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Thu, 06 Jun 2024 17:39:01 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 10/15] libtracefs: prevent memory leak in tracefs_instance_create()
Date: Thu,  6 Jun 2024 17:38:24 +0200
Message-ID: <20240606153830.2666120-11-jmarchan@redhat.com>
In-Reply-To: <20240606153830.2666120-1-jmarchan@redhat.com>
References: <20240606153830.2666120-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Free the path of the instance directory in the error path.

Fixes a RESSOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 src/tracefs-instance.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index 9a26708..dd7decd 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -217,6 +217,7 @@ struct tracefs_instance *tracefs_instance_create(const char *name)
 	return inst;
 
 error:
+	tracefs_put_tracing_file(path);
 	tracefs_instance_free(inst);
 	return NULL;
 }
-- 
2.44.0

