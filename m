Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA6F1953AF
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594879; cv=none; b=S3YgQIarLKDyUgsssw8m36RhnklwpVQg9yk2PY657n48mweGBRvZ710k+6DbdP9A5bEgpL79rRXeVj3xc0+OxfVAmdSSpyGUAltXA5HtfXprEk//NWOQrr4YeeeBzDxISgsR81lNRrT1hYBr4Mz29F2YQaTb0kBNVPYUXhbAVko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594879; c=relaxed/simple;
	bh=fE4pa+EZKd10ub6G12ivLf5vbbfIfTkWVofOcX/uFIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p48E1QP3MBA0tG36FahI4+9r4xhQVBisbjza3zkXlrT3GZh4+ObwBrsBfQIL4aBJVg2QJ9lKXPUQgzd+oo2h0MRGBRXrZ+i2przrAkK+e4p82zwQSE9IMwUIMcotzi8s591QDDQwnBMQVIeB3PxRq44IHl4TLkRw0DCAmTBC+wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PmcwoaLW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PmcwoaLW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JlWyOLogzAhq47uomDvl+vnyySl8hlXXeiMSg2kvXRI=;
	b=PmcwoaLW517nOWsLdH39zDQ5qZ2nLAErCZRee7p/V9igV3Y4VlPLvjIEQb0Yzau098ogYD
	0uD/YVJzvbfWHAR4oBsBmTwTu77bZZ+4TSFCtu7E/rAIY3djdQz1AWAGHdcaEtOHDghn1L
	6CWf1rpTD7HoJUeJJ7F7sZkplfIPjo8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-589-BqJJPvAxOcOW73_FdwR91Q-1; Wed,
 05 Jun 2024 09:41:16 -0400
X-MC-Unique: BqJJPvAxOcOW73_FdwR91Q-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4BE1A1955DB9;
	Wed,  5 Jun 2024 13:41:15 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 550441955E8E;
	Wed,  5 Jun 2024 13:41:11 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:41:10 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 04/38] trace-cmd: call dlclose() in the error path of load_plugin()
Date: Wed,  5 Jun 2024 15:40:19 +0200
Message-ID: <20240605134054.2626953-5-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

The handle returned by dlopen() isn't closes if something else fails
afterwards. Call dlclose in the error path to fix that.

Fixes a RESOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 lib/trace-cmd/trace-plugin.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/trace-plugin.c b/lib/trace-cmd/trace-plugin.c
index 127771ea..0d477dff 100644
--- a/lib/trace-cmd/trace-plugin.c
+++ b/lib/trace-cmd/trace-plugin.c
@@ -126,13 +126,13 @@ load_plugin(struct trace_plugin_context *trace, const char *path,
 	if (!func) {
 		tracecmd_warning("could not find func '%s' in plugin '%s'\n%s",
 				 TRACECMD_PLUGIN_LOADER_NAME, plugin, dlerror());
-		goto out_free;
+		goto out_close;
 	}
 
 	list = malloc(sizeof(*list));
 	if (!list) {
 		tracecmd_warning("could not allocate plugin memory");
-		goto out_free;
+		goto out_close;
 	}
 
 	list->next = *plugin_list;
@@ -143,7 +143,9 @@ load_plugin(struct trace_plugin_context *trace, const char *path,
 	tracecmd_info("registering plugin: %s", plugin);
 	func(trace);
 	return;
-
+	
+out_close:
+	dlclose(handle);
  out_free:
 	free(plugin);
 }
-- 
2.44.0

