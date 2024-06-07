Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69889199235
	for <linux-trace-devel@vger.kernel.org>; Fri,  7 Jun 2024 16:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717776361; cv=none; b=B7UDw+9lBHFnalxTeTj9b0cQFGZkIr+a/oTWCqJ/bmHZP2cQxkrLxH5XOyCYCiib4UXckLt2BcQ75KojzfxbxDHA7TJho4xBj+H1LLturx/yr/DC3CodXGC4xk3xoM/DtAr8imflCpoGpAgV1xaU1m4sxUolS86zKOoYplBvt0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717776361; c=relaxed/simple;
	bh=nruzFuTsBNDXZZiXmfMzJBIVSPP17MfBvbKxVXnoFhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOlo21xsWhdCUc/I5BFRqqTFXzrcQWgFh5rFofIcLTejSCvZUtgJ7nPCPkemHLf9MVkWWMdM0P+ApgPH8u348tve9UkqIGdC6N35j2Ikq1/NsOKmii0SSdysb/V5e6mbzTfwVqF41mfwtZ/3ZkIx0b47zcGjn7BLynGizWKYuS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hs/CwTLX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hs/CwTLX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717776359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dMdugO/WaTtMBYpR27KdFJufV5lq6opB5QI665paLsQ=;
	b=Hs/CwTLXuuNIppQERcIta2qIaPpiLkiB7qpW1QSUzowd8SopzW1SBvvGlu/mCWm5FvMkwa
	hVgv/u7fyBI8HD0RA6GINOY1l3aAigZL13lUQo/cVEh9y1H0XUltsTw5AJqlBYCCXFDmhx
	LCFlYK6zlJ3DlWaEf0cll+Fw17A6qG8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-530-KsLXKJ34NyKeaDhvN2ObDg-1; Fri,
 07 Jun 2024 12:05:56 -0400
X-MC-Unique: KsLXKJ34NyKeaDhvN2ObDg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2BD8519560BF;
	Fri,  7 Jun 2024 16:05:55 +0000 (UTC)
Received: from fedora (unknown [10.43.17.163])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id E97231956089;
	Fri,  7 Jun 2024 16:05:52 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Fri, 07 Jun 2024 18:05:51 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 3/4] libtraceevent: prevent a memory leak in tep_plugin_add_option()
Date: Fri,  7 Jun 2024 18:05:41 +0200
Message-ID: <20240607160542.46152-4-jmarchan@redhat.com>
In-Reply-To: <20240607160542.46152-1-jmarchan@redhat.com>
References: <20240607160542.46152-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

If parse_option_name() fails, plugin, which now points to the previous
value of option_str isn't freed. Go to out_free if that happen.

Fixes a RESOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 src/event-plugin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/event-plugin.c b/src/event-plugin.c
index 7f94107..c944204 100644
--- a/src/event-plugin.c
+++ b/src/event-plugin.c
@@ -327,7 +327,7 @@ int tep_plugin_add_option(const char *name, const char *val)
 		return -ENOMEM;
 
 	if (parse_option_name(&option_str, &plugin) < 0)
-		return -ENOMEM;
+		goto out_free;
 
 	/* If the option exists, update the val */
 	for (op = trace_plugin_options; op; op = op->next) {
-- 
2.45.1

