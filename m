Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9CB2199235
	for <linux-trace-devel@vger.kernel.org>; Fri,  7 Jun 2024 16:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717776383; cv=none; b=ouq9BHZfIOBmz5gmFFuwgPaZszJsV8aS6cAY9exAk2jq7u5j5ucfNV7BjJAoUhOBbuowrBLZ68JE/FQR2TaoulKUXbgUb90V8uqx3igFpkXfdW514Kqy2s64LgSzaEQlZadfTpC627RkdAogd3Ef7JE1J9VXAE3Py+N7f+Qr1Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717776383; c=relaxed/simple;
	bh=+HkE0Yycd2sUvBfzcqe99wHc7UFrOxmnYcm9THzggSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EK32nhEhEnsDPsdEyA+hD62VhrgzB4a0SmRardcgR/DXAR5HGC/rGDq2xKywXlT8urb9lQE0yLZmsnZC3yqPKX9R12vNq2oe7J0KYuUM3OiSypUgEinZyUl5UWf7j/f8pTmS/2+He7MOOTz2N8Vrkxp9h/SxB4PK2++W7SEY9hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MbK+o+Pj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MbK+o+Pj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717776380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p+CWfzSLt13XdfnfRfCgw1b04HUqNWVPp9FoFuyIy04=;
	b=MbK+o+PjLHCuqdfSDQxeIgQutRRwqZ1LtIyZdlnLXhGbH8FRCRCGhPv5UFQATv5bW7UYqR
	AlnXPHMY0x+sapSynQTgjusj/Ms5RCTg3K8Bmq7dPAv98BUbOvoYABmpHsHNVWxk+Mix64
	tICLHvSPQc5n51tXydnk0thbM0BmDVY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-iSllhg4cO_-kD6jJkql_zA-1; Fri, 07 Jun 2024 12:05:48 -0400
X-MC-Unique: iSllhg4cO_-kD6jJkql_zA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A6263185A780;
	Fri,  7 Jun 2024 16:05:47 +0000 (UTC)
Received: from fedora (unknown [10.43.17.163])
	by smtp.corp.redhat.com (Postfix) with SMTP id 225391121337;
	Fri,  7 Jun 2024 16:05:46 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Fri, 07 Jun 2024 18:05:45 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 1/4] libtraceevent: close shared object in the error path of load_plugin()
Date: Fri,  7 Jun 2024 18:05:39 +0200
Message-ID: <20240607160542.46152-2-jmarchan@redhat.com>
In-Reply-To: <20240607160542.46152-1-jmarchan@redhat.com>
References: <20240607160542.46152-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

The handle returned by dlopen() isn't close if an error occures
afterward. Call dlclose() in the error path.

Fixes a RESOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 src/event-plugin.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/src/event-plugin.c b/src/event-plugin.c
index f42243f..7f94107 100644
--- a/src/event-plugin.c
+++ b/src/event-plugin.c
@@ -474,7 +474,7 @@ load_plugin(struct tep_handle *tep, const char *path,
 		while (options->name) {
 			ret = update_option(alias, options);
 			if (ret < 0)
-				goto out_free;
+				goto out_close;
 			options++;
 		}
 	}
@@ -483,13 +483,13 @@ load_plugin(struct tep_handle *tep, const char *path,
 	if (!func) {
 		tep_warning("could not find func '%s' in plugin '%s'\n%s\n",
 			    TEP_PLUGIN_LOADER_NAME, plugin, dlerror());
-		goto out_free;
+		goto out_close;
 	}
 
 	list = malloc(sizeof(*list));
 	if (!list) {
 		tep_warning("could not allocate plugin memory\n");
-		goto out_free;
+		goto out_close;
 	}
 
 	list->next = *plugin_list;
@@ -501,6 +501,8 @@ load_plugin(struct tep_handle *tep, const char *path,
 	func(tep);
 	return;
 
+out_close:
+	dlclose(handle);
  out_free:
 	free(plugin);
 }
-- 
2.45.1

